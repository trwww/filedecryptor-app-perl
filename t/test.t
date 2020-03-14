use warnings;
use strict;

use FindBin;
$FindBin::Bin =~ /(.*)/; $FindBin::Bin = $1; # untaint

use File::Copy;
use Test::More tests => 5;

my $test_encrypted_file  = "$FindBin::Bin/test.pgp";
my $file_to_be_decrypted = "$FindBin::Bin/data/test.pgp";
my $decrypted_file       = "$FindBin::Bin/data/test.txt";
my $driver_script        = "$FindBin::Bin/../bin/decrypt.pl";

unlink( $decrypted_file ); # delete unencrypted file if it exists

ok(
  ! -e $decrypted_file,
  'sanity check to make sure file decrypted file does not exist'
);

ok(
  copy( $test_encrypted_file, $file_to_be_decrypted ),
  'copy test encrypted file to location speced in the config'
);

ok(
  -e $file_to_be_decrypted,
  'sanity check to make sure file to be decrypted exists'
);

is(
  system( $driver_script => 'test'), 0, 'ran driver sucessfully'
) or diag("driver run failed: $?");

ok( -e $decrypted_file, 'decrypted file now exists' );

