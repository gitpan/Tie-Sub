use 5.006001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile (
  NAME         => 'Tie::Sub',
  VERSION_FROM => 'lib/Tie/Sub.pm',   # finds $VERSION
  PREREQ_PM    => {   # e.g., Module::Name => 1.1
    Test::More => 0.47,
  },
  ( $] >= 5.005 ? (  ## Add these new keywords supported since 5.005
      ABSTRACT_FROM  => 'lib/Tie/Sub.pm',   # retrieve abstract from module
      AUTHOR         => 'Steffen Winkler <cpan@steffen-winkler.de>',
      INSTALLSITELIB => undef,
      dist => {
        COMPRESS => 'gzip -9f',
        SUFFIX   => 'gz',
      },
    )
    : ()
  ),
);
