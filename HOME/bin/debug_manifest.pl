#!/usr/bin/env perl
use strict;
use warnings;

# enDeCrypt installation directory (replaced by install.sh)
# use lib "/Users/brooke/dev/amnesia/2025-06-18_selectEncRatedContent/enDeCrypt";

# For running directly from project directory
use FindBin;
use lib "$FindBin::Bin";
use FileCrypto;

# Check for directory argument
my $target_dir = ".";
my $manifest_file = "MANIFEST.txt.enc";

if (@ARGV > 0) {
    $target_dir = $ARGV[0];
    $manifest_file = "$target_dir/MANIFEST.txt.enc";
}

# Check if file exists
if (!-f $manifest_file) {
    print "Error: $manifest_file not found\n";
    print "Usage: $0 [directory]\n";
    print "  If no directory specified, looks in current directory\n";
    exit 1;
}

# Create crypto object and use centralized method
my $crypto = FileCrypto->new(debug => 1);
my $result = $crypto->debug_manifest($manifest_file);

if ($result->{success}) {
    print "✓ $result->{message}\n";
} else {
    print "✗ $result->{error}\n";
    exit 1;
}