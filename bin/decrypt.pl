#!/usr/bin/env perl

# crontab entry
# 0 8 * * 1-5 /opt/home/trwww/apps/filedecryptor/bin/decrypt.pl

use warnings;
use strict;

use Log::Log4perl;

use FindBin;
use lib "$FindBin::Bin/../lib";

use FileDecryptor::ConfigLoader;
use FileDecryptor::Runtime;

die("usage: $0 config\n") unless $ARGV[0];

Log::Log4perl->init( \*DATA );
my $log = Log::Log4perl->get_logger;
$log->info("started file decryptor program");

my $conf = FileDecryptor::ConfigLoader->load(
  log => $log,
  file => $ARGV[0],
);
$log->debug("loaded config for $conf->{name}");

my $decrypt = FileDecryptor::Runtime->new(
  conf => $conf,
  log  => $log,
);
$log->debug("instantiated decryptor runtime");

$decrypt->prepare;
$log->debug("completed preparation cycle");

$decrypt->decrypt;
$log->debug("completed decryption cycle");

$decrypt->finish;
$log->debug("completed finish cycle");

$log->info("ending file decryptor program");


__DATA__
############################################################
# A simple root logger with a Log::Log4perl::Appender::File 
# file appender in Perl.
############################################################
log4perl.rootLogger=DEBUG, LOGFILE

log4perl.appender.LOGFILE=Log::Log4perl::Appender::File
log4perl.appender.LOGFILE.filename=sub { "$FindBin::Bin/../logs/$ARGV[0].log" }
log4perl.appender.LOGFILE.mode=append

log4perl.appender.LOGFILE.layout=PatternLayout
log4perl.appender.LOGFILE.layout.ConversionPattern=(%d) %C %L [%p] - %m%n
