# filedecryptor-app-perl

Perl utility app to Decrypt PGP Encrypted Files with GnuPG1.

When ran with the basename of a config file as an argument, this utility will look for files in a configured directory. For every file in the directory, it will move it to an archive directory, and then decrypt it with the `gpg` binary found in `$PATH`. It assumes the `gpg` binary found is GnuPG1.

Reference conf/test.conf for a sample configuration.

### GnuPG requirements

The perl [GnuPG](https://metacpan.org/pod/GnuPG) library only works with gnupg1, whereas most modern systems now ship with gnupg2.

### test script

this script has a test so you can see it perform if you have a couple prereqs installed
* GnuPG
* Log::Log4perl
* YAML

see t/test.t

---

1. extract filedecryptor.tgz: tar -zxf filedecryptor.tgz
1. cd filedecryptor
1. verify gpg is less than version 2: gpg --version
1. verify YAML, Log::Log4perl, and GnuPG is installed (make will install them for you)
1. if your env program is not at /usr/bin/env, update bin/decrypt.pl
1. run the test script: prove -r -l -v t

