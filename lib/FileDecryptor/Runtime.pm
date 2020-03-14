use warnings;
use strict;

package FileDecryptor::Runtime;

use File::Copy;
use File::Basename;
use GnuPG;

sub new {
  my( $class, @args ) = @_;
  my $self = bless( { @args }, $class );
  $self->init;
  return $self;
}

sub init {
  my $self = shift;
  $self->{log}->debug('instantiated runtime');
}

=pod

move encrypted files to archive directory
store names of files that were moved

=cut

sub prepare {
  my $self = shift;

  $self->{files} = [ ];
  my $sdir = $self->{conf}{source};
  my $edir = $self->{conf}{archive}{encrypted};

  foreach my $sourcepath ( glob("$sdir/*.pgp") ) {
    my $file = fileparse $sourcepath, '.pgp';
    my $destpath = "$edir/$file.pgp";
    if ( move($sourcepath, $destpath) ) {
      push( @{$self->{files}}, $file );
      $self->{log}->debug( "${file}.pgp: moved from fileadmin area" );
    } else {
      $self->{log}->logdie( "${file}.pgp: $!" );
    }
  }

  $self->{log}->info( @{$self->{files}} .  " files prepared" );
}

=pod

decrypt encrypted files

=cut

sub decrypt {
  my $self = shift;
  
  my $passphrase = $self->{conf}{gnupg}{passphrase};
  my $homedir    = $self->{conf}{gnupg}{ homedir  };
  my $options    = $self->{conf}{gnupg}{ options  };

  my $edir = $self->{conf}{archive}{encrypted};
  my $ddir = $self->{conf}{archive}{decrypted};

  my $gpg = GnuPG->new( homedir => $homedir, options => $options );


  foreach my $file ( @{$self->{files}} ) {
    my $ciphertext = "$edir/${file}.pgp";
    my $output     = "$ddir/${file}.txt";
    eval {
      $gpg->decrypt(
        ciphertext => $ciphertext,
        output     => $output,
        passphrase => $passphrase,
      )
    };

    if ( $@ ) {
      $self->{log}->logdie( "$ciphertext - could not decrypt: $@" );
    } else {
      $self->{log}->debug( "$ciphertext -> $output" );
    }
  }

  $self->{log}->info( @{$self->{files}} . ' files decrypted' );
}

=pod

move decrypted files to source directory

=cut

sub finish {
  my $self = shift;
  
  my $sdir = $self->{conf}{source};
  my $ddir = $self->{conf}{archive}{decrypted};
  
  foreach my $file ( @{$self->{files}} ) {
    my $dfile = "$ddir/${file}.txt";
    my $sfile = "$sdir/${file}.txt";

    if ( move($dfile, $sfile) ) {
      $self->{log}->debug( "${file}.txt: moved to fileadmin area" );
    } else {
      $self->{log}->logdie( "$sfile: $!" );
    }
  }

  $self->{log}->info( @{$self->{files}} . ' files processed' );
}

1;

