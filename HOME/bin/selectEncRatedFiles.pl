#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;
use File::Find;
use File::Spec;
use File::Basename;
use List::Util qw(shuffle);

# Script version and database format
my $SCRIPT_VERSION = "1.0";
my $DB_FORMAT_VERSION = 1;

# Global variables
my %database;
my $action_from = 0;
my @valid_extensions = qw(jpg jpeg png gif bmp tiff webp heic mp4 avi mkv mov wmv flv webm m4v);
my %ext_lookup = map { lc($_) => 1 } @valid_extensions;

# Command line options
my ($db_file, $start_dir, $action, $outdir, $help, $simulate);

# Configuration
my $script_name = basename($0, '.pl');  # Remove .pl extension for config
my $config_dir = File::Spec->catdir($ENV{HOME}, '.config');
my $config_file = File::Spec->catfile($config_dir, "$script_name.conf");

sub show_help {
    my $script_name = basename($0);
    print <<"EOF";
$script_name - Media File Processing and Encryption Script

DESCRIPTION:
    Recursively scans for directories/files starting with '8-10', '9-10', or '10-10'
    containing image/video files. Tracks processing history in a database and can
    randomly select files for encryption using encryptFile.sh.

USAGE:
    $script_name [OPTIONS]

OPTIONAL ARGUMENTS:
    --db <file>         Database file to track processed files/directories
                        (if not specified, reads from ~/.config/[scriptname].conf)
    --start <dir>       Starting directory for scan (default: current directory)
    --action <action>   Action to perform:
                          <number>  - Select N random unprocessed files/dirs
                          reset     - Reset processing cycle (increment action_from)
                          rescan    - Re-scan filesystem and update database
    --outdir <dir>      Output directory for encrypted files (required for number actions)
    --simulate          Perform action without calling encryptFile.sh or saving database
                        (shows what would happen, updates in-memory database only)
    --help, -h          Show this help message

CONFIGURATION:
    On first run, creates ~/.config/[scriptname].conf with the --db path.
    Subsequent runs will use this configuration unless --db is explicitly provided.

EXAMPLES:
    # Initial setup (creates config file and scans)
    $script_name --db ./media.db

    # Select 5 random files/directories for processing
    $script_name --action 5 --outdir /tmp/encrypted

    # Simulate selecting 3 files (no actual encryption or database save)
    $script_name --action 3 --outdir /tmp/test --simulate

    # Reset processing cycle when all files have been processed
    $script_name --action reset

    # Rescan for new files
    $script_name --action rescan --start /media/photos

NOTES:
    - Only processes image/video files with common extensions
    - Directories must start with '8-10', '9-10', or '10-10' to be considered
    - Uses encryptFile.sh (must be in PATH) for encryption
    - Database format version: 1
    - Automatically rescans on first run if database doesn't exist

EOF
}

sub load_config {
    return unless -f $config_file;
    
    open my $config_fh, '<', $config_file or die "Cannot read config file '$config_file': $!\n";
    
    while (my $line = <$config_fh>) {
        chomp $line;
        next if $line =~ /^\s*$/ || $line =~ /^#/;
        
        if ($line =~ /^db_file=(.+)$/) {
            $db_file ||= $1;  # Only set if not already specified on command line
        }
    }
    
    close $config_fh;
}

sub save_config {
    # Create config directory if it doesn't exist
    unless (-d $config_dir) {
        mkdir $config_dir or die "Cannot create config directory '$config_dir': $!\n";
    }
    
    open my $config_fh, '>', $config_file or die "Cannot write config file '$config_file': $!\n";
    
    my $script_name = basename($0);
    print $config_fh "# $script_name configuration\n";
    print $config_fh "db_file=$db_file\n";
    
    close $config_fh;
    print "Saved configuration to: $config_file\n";
}

sub parse_arguments {
    # Load config first
    load_config();
    
    GetOptions(
        'db=s'      => \$db_file,
        'start=s'   => \$start_dir,
        'action|a=s' => \$action,
        'outdir=s'  => \$outdir,
        'simulate'  => \$simulate,
        'help|h'    => \$help,
    ) or die "Error parsing command line arguments. Use --help for usage.\n";

    if ($help) {
        show_help();
        exit 0;
    }

    # If no db_file specified and no config exists, require it
    unless ($db_file) {
        my $script_name = basename($0);
        print STDERR "Error: --db argument is required (or set in ~/.config/$script_name.conf)\n\n";
        show_help();
        exit 1;
    }

    # Save config if db_file was specified on command line
    if ($db_file && (!-f $config_file || !load_config())) {
        save_config();
    }

    # Set defaults
    $start_dir ||= '.';
    
    # Validate action-specific requirements
    if ($action && $action =~ /^\d+$/ && !$outdir) {
        print STDERR "Error: --outdir is required when action is a number\n\n";
        show_help();
        exit 1;
    }
}

sub load_database {
    %database = ();
    $action_from = 0;
    
    my $db_exists = -f $db_file;
    
    if (!$db_exists) {
        print "Database file '$db_file' doesn't exist. Will perform initial rescan.\n";
        return;
    }
    
    open my $db_fh, '<', $db_file or die "Cannot read database file '$db_file': $!\n";
    
    my $format_version;
    while (my $line = <$db_fh>) {
        chomp $line;
        next if $line =~ /^\s*$/ || $line =~ /^#/;
        
        if ($line =~ /^db_format=(\d+)$/) {
            $format_version = $1;
            if ($format_version != $DB_FORMAT_VERSION) {
                die "Database format version $format_version not supported. Expected version $DB_FORMAT_VERSION\n";
            }
        } elsif ($line =~ /^action_from=(\d+)$/) {
            $action_from = $1;
        } elsif ($line =~ /^(.+)=(\d+)$/) {
            $database{$1} = $2;
        }
    }
    
    close $db_fh;
    print "Loaded database: " . scalar(keys %database) . " entries, action_from=$action_from\n";
}

sub save_database {
    if ($simulate) {
        print "[SIMULATE] Would save database: " . scalar(keys %database) . " entries, action_from=$action_from\n";
        return;
    }
    
    open my $db_fh, '>', $db_file or die "Cannot write database file '$db_file': $!\n";
    
    print $db_fh "db_format=$DB_FORMAT_VERSION\n";
    print $db_fh "action_from=$action_from\n";
    
    for my $path (sort keys %database) {
        print $db_fh "$path=$database{$path}\n";
    }
    
    close $db_fh;
    print "Saved database: " . scalar(keys %database) . " entries, action_from=$action_from\n";
}

sub is_valid_media_file {
    my ($file) = @_;
    my $ext = lc((fileparse($file, qr/\.[^.]*/))[2]);
    $ext =~ s/^\.//;  # Remove leading dot
    return exists $ext_lookup{$ext};
}

sub matches_rating_pattern {
    my ($name) = @_;
    return $name =~ /^(?:8-10|9-10|10-10)/;
}

sub scan_directory {
    my ($dir) = @_;
    my @found_paths = ();
    
    print "Scanning directory: $dir\n";
    
    find({
        wanted => sub {
            my $path = $File::Find::name;
            my $name = basename($path);
            
            # Skip if doesn't match rating pattern
            return unless matches_rating_pattern($name);
            
            if (-d $path) {
                # Check if this directory contains any media files (directly or in subdirs)
                opendir my $dh, $path or return;
                my @entries = grep { $_ ne '.' && $_ ne '..' } readdir($dh);
                closedir $dh;
                
                my $has_subdirs = 0;
                my $has_media_direct = 0;
                my $has_media_nested = 0;
                
                # Check direct contents
                for my $entry (@entries) {
                    my $entry_path = File::Spec->catfile($path, $entry);
                    if (-d $entry_path) {
                        $has_subdirs = 1;
                        # Check if subdirectory contains media files
                        opendir my $sub_dh, $entry_path or next;
                        my @sub_entries = grep { $_ ne '.' && $_ ne '..' } readdir($sub_dh);
                        closedir $sub_dh;
                        
                        for my $sub_entry (@sub_entries) {
                            my $sub_entry_path = File::Spec->catfile($entry_path, $sub_entry);
                            if (-f $sub_entry_path && is_valid_media_file($sub_entry)) {
                                $has_media_nested = 1;
                                last;
                            }
                        }
                    } elsif (-f $entry_path && is_valid_media_file($entry)) {
                        $has_media_direct = 1;
                    }
                }
                
                # Add directory if it has media files (either direct or in immediate subdirs)
                if ($has_media_direct || $has_media_nested) {
                    push @found_paths, $path;
                    if ($has_media_direct && !$has_subdirs) {
                        print "Found leaf directory: $path\n";
                    } elsif ($has_media_direct && $has_subdirs) {
                        print "Found mixed directory: $path (has files and subdirs)\n";
                    } elsif ($has_media_nested) {
                        print "Found parent directory: $path (has media in subdirs)\n";
                    }
                }
            } elsif (-f $path && is_valid_media_file($path)) {
                # Individual media file with matching rating pattern
                push @found_paths, $path;
                print "Found media file: $path\n";
            }
        },
        no_chdir => 1,
    }, $dir);
    
    return @found_paths;
}

sub rescan_filesystem {
    print "Rescanning filesystem starting from: $start_dir\n";
    my @found_paths = scan_directory($start_dir);
    
    # Add new paths to database
    my $new_count = 0;
    for my $path (@found_paths) {
        unless (exists $database{$path}) {
            $database{$path} = 0;
            $new_count++;
        }
    }
    
    print "Found $new_count new paths, total in database: " . scalar(keys %database) . "\n";
}

sub select_random_files {
    my ($count) = @_;
    
    # Get files that haven't been processed at current action_from level
    my @available = grep { $database{$_} <= $action_from } keys %database;
    
    if (@available == 0) {
        print "All files have been processed at action_from level $action_from.\n";
        print "Use 'reset' action to increment the processing cycle.\n";
        return ();
    }
    
    # Sort by action count (prefer lower counts)
    @available = sort { $database{$a} <=> $database{$b} } @available;
    
    # If we need more files than available, take all available
    $count = @available if $count > @available;
    
    # Shuffle files with the same (lowest) action count
    my $lowest_count = $database{$available[0]};
    my @lowest_files = grep { $database{$_} == $lowest_count } @available;
    my @higher_files = grep { $database{$_} > $lowest_count } @available;
    
    @lowest_files = shuffle(@lowest_files);
    @available = (@lowest_files, @higher_files);
    
    # Select the requested number
    my @selected = splice(@available, 0, $count);
    
    print "Selected $count files/directories:\n";
    for my $path (@selected) {
        my $old_count = $database{$path};
        print "  $path (previously actioned $old_count times";
        if ($simulate) {
            print " -> would become " . ($old_count + 1) . ")\n";
            # In simulate mode, temporarily update for display but don't actually change
        } else {
            $database{$path}++;
            print " -> now " . $database{$path} . ")\n";
        }
    }
    
    return @selected;
}

sub encrypt_files {
    my (@paths) = @_;
    
    return unless @paths;
    
    # Build command
    my @cmd = ('encryptFile.sh');
    push @cmd, '--outdir', $outdir if $outdir;
    push @cmd, @paths;
    
    if ($simulate) {
        print "[SIMULATE] Would execute: " . join(' ', @cmd) . "\n";
        print "[SIMULATE] Encryption would process " . scalar(@paths) . " files/directories.\n";
        return;
    }
    
    print "Executing: " . join(' ', @cmd) . "\n";
    
    # Execute encryptFile.sh
    my $result = system(@cmd);
    
    if ($result == 0) {
        print "Encryption completed successfully.\n";
    } else {
        print "Encryption failed with exit code: " . ($result >> 8) . "\n";
        exit 1;
    }
}

sub main {
    parse_arguments();
    load_database();
    
    # Auto-rescan if database doesn't exist
    my $needs_initial_scan = !-f $db_file || scalar(keys %database) == 0;
    
    if (!$action) {
        if ($needs_initial_scan) {
            print "No action specified and database is empty. Performing initial rescan...\n";
            rescan_filesystem();
            save_database();
        } else {
            print "No action specified. Use --help for usage information.\n";
        }
        exit 0;
    }
    
    if ($action eq 'rescan') {
        rescan_filesystem();
    } elsif ($action eq 'reset') {
        my $old_action_from = $action_from;
        $action_from++;
        if ($simulate) {
            print "[SIMULATE] Would reset processing cycle. action_from would change from $old_action_from to $action_from.\n";
        } else {
            print "Reset processing cycle. action_from changed from $old_action_from to $action_from.\n";
        }
    } elsif ($action =~ /^\d+$/) {
        # Auto-rescan if needed before selecting files
        if ($needs_initial_scan) {
            print "Database is empty. Performing initial rescan before selection...\n";
            rescan_filesystem();
        }
        
        my @selected = select_random_files($action);
        encrypt_files(@selected) if @selected;
    } else {
        print STDERR "Invalid action '$action'. Use --help for valid actions.\n";
        exit 1;
    }
    
    save_database();
}

# Run the script
main();
