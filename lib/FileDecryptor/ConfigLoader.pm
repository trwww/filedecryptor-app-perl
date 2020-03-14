use warnings;
use strict;

use YAML ();

package FileDecryptor::ConfigLoader;

sub load {
  my( $proto, %args ) = @_;

  my $file = $args{file};
  my $log  = $args{log};

  my $filepath = "$FindBin::Bin/../conf/$file.conf";
  if ( ! -e $filepath ) {
    $log->logdie( "$filepath: no such file" );
  }

  my $conf = YAML::LoadFile( $filepath );
  return $conf;
}

1;
