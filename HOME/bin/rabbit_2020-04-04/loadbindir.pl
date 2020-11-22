#!/usr/bin/perl -w
# File: loadbindir.pl
# Created: Brooke Smith 2007 10 20
# Purpose: We can't afford to load every bin dir for everything we add to the system so instead
#		We have a bin dir ($LOADEDBINDIR) that we create sym links to all the apps executables in.
#		FEATURES:
#			1. Directories with executables are listed in $LOADEDBINDIR/apps.list
#			2. Executables in these directories will be symlinked to from $LOADEDBINDIR
#			3. Symlinks not in directories from $LOADEDBINDIR/apps.list will be deleted (to keep clean)
#
# How it works:
#		$LOADEDBINDIR is the directory sym links are created in.
#		In $LOADEDBINDIR/apps.list is listed all the application bin dirs containing the executables.
# 	The list in this can be added to.
#			# Create sym link if doesn't exist
#			For each $ex = executable in dirs listed in apps.list
#				if no symlink to that in $LOADEDBINDIR then
#					create it
#					record as having been created (valid symlink)
#				else 
#					record as valid symlink
#				fi
#			end
#			# Check if have any symlinks can get rid of
#			for each $sl = symlink in $LOADEDBINDIR
#				if $sl not marked as valid then
#					rm $sl
#				fi
#			end

my $gDEBUG = 1;					# debug level 1..5
my %gExistingSymLinks; 	# Keep list of existing symlinks
my %gValidSymlinks;			# Keep a list of the valid symlinks
my $gLoadedBinDir = $ENV{LOADEDBINDIR};
my $gAppsListFile = "apps.list";	# File with dirs

if ( ! $gLoadedBinDir ) {
	die("$0 - ERROR - Env Var LOADEDBINDIR isnt set.");
}

if ( ! -d $gLoadedBinDir) {
	`mkdir -p $gLoadedBinDir`;
}

# If no $LOADEDBINDIR/apps.list then exit.  it isn't an error, just that it hasn't started to be
#		populated yet.
if (! -e "$gLoadedBinDir/$gAppsListFile" ) {
	print STDERR "ListApps file doesnt exist - $gLoadedBinDir/$gAppsListFile\n";
  exit 0;
}

#function processAppDir() {
#	echo processAppDir
#}

# Read in the symlinks in $gLoadedBinDir
print STDERR "Inspect bin directory - $gLoadedBinDir\n" if ($gDEBUG >= 2);
opendir(BINDIR, "$gLoadedBinDir") || die("$0 - cant open dir gLoadedBinDir - $gLoadedBinDir");
my @gBinDir = grep !/^\.\.?/, readdir BINDIR;
foreach my $lBinDir (@gBinDir) {
	$gExistingSymLinks{$lBinDir}=1;
	print STDERR "  file $lBinDir\n" if ($gDEBUG >= 2);	#r (added to gExistingSymLinks)\n";
}
close BINDIR;

if ($gDEBUG >= 4) {
	print STDERR "gExistingSymLinks:\n";
	foreach my $lExisting (keys %gExistingSymLinks) {
		print STDERR "  Existing symlink: $lExisting -> $gExistingSymLinks{$lExisting}\n";
	}
}

# Parse apps.list for directories specified in it
print STDERR "Parse AppList ($gLoadedBinDir/$gAppsListFile) for dirs to inspect:\n" if ($gDEBUG >= 2);
open(APPSLIST, "$gLoadedBinDir/$gAppsListFile") || die("$0 - cant open gLoadedBinDir/apps.list - $gLoadedBinDir/$gAppsListFile");

while (<APPSLIST> ) {
	chomp;
	if (/^\W*#/) {
		print STDERR "  # Comment: $'\n" if ($gDEBUG >= 2);
		next;
	}
	next if (/^\W*$/);			# Empty lines
	my $lAppDir = $_;
	print STDERR "  '$lAppDir'\n" if ($gDEBUG >= 2);
	if (! -d $lAppDir) {
		print STDERR "  WARNING - Appdir: $lAppDir isnt a directory.";
	} else {
		opendir(APPDIR,"$lAppDir") || die("$0 - cant open AppDir - $lAppDir");
		my @lAppDirGuts = grep !/^\.\.?/, readdir APPDIR;
		foreach my $lAppDirItem (@lAppDirGuts) {
			print STDERR "    item: $lAppDirItem\n" if ($gDEBUG >= 2);
			if ($gExistingSymLinks{$lAppDirItem}) {
				print STDERR "       -item already exists as symlink\n" if ($gDEBUG >= 2);
				$gValidSymlinks{$lAppDirItem}=1;
			} elsif ( -x "$lAppDir/$lAppDirItem" && ! -d "$lAppDir/$lAppDirItem" ) {
				my $lSource="$lAppDir/$lAppDirItem";
				my $lDest = "$gLoadedBinDir/$lAppDirItem";
				# Check if the sym link already exists
				if ( -e $lDest ) {
					print STDERR "      - destination sym link already exists - $lDest - so not creating.\n" if ($gDEBUG >= 2);
				} else {
					print STDERR "      - item does not exist as symlink - create symlink\n" if ($gDEBUG >= 2);	#source: $lSource, dest: $lDest\n";
					symlink($lSource, $lDest) || die("$0 - Can't make symlink - source: $lSource, dest: $lDest");
					$gValidSymlinks{$lAppDirItem}=1;
				}
			} elsif (-d "$lAppDir/$lAppDirItem") {
				print STDERR "      - file is a directory so not making symlink for.\n" if ($gDEBUG >= 2);			
			} else {
				print STDERR "      - file isnt executable so not making symlink for.\n" if ($gDEBUG >= 2);
			}
		}
	}
	close APPDIR;
}

close APPSLIST;

# Now go through %gExistingSymLinks and delete any that aren't in %gValidSymlinks
# 	Except apps.list ofcourse.
print STDERR "Go through bin directory and delete any files / links that werent referenced in apps.list:\n" if ($gDEBUG >= 2);
foreach my $lExisting (keys %gExistingSymLinks) {
	print STDERR "  Existing symlink: $lExisting " if ($gDEBUG >= 2);
	if ($gValidSymlinks{$lExisting}) {
		print STDERR " - is valid.\n" if ($gDEBUG >= 2);
	} elsif ($lExisting =~ /$gAppsListFile/) {
		print STDERR " - is $gAppsListFile so keeping!.\n" if ($gDEBUG >= 2);
	} else {
		print STDERR " - is NOT valid so deleting.\n" if ($gDEBUG >= 2);
		unlink "$gLoadedBinDir/$lExisting";
	}
}
	