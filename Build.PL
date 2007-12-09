use strict;
use warnings;

use Module::Build;

my $build = Module::Build->new(
    module_name       => 'Tie::Sub',
    license           => 'perl',
    dist_author       => 'Steffen Winkler <steffenw@cpan.org>',
    dist_version_from => 'lib/Tie/Sub.pm',
    requires          => {
        Carp               => '0',
        'Params::Validate' => '0',
    },
    build_requires    => {
        'Test::More' => '0',
    },
    create_makefile_pl   => 'traditional',
    recursive_test_files => 1,
    add_to_cleanup       => [
        'META.yml', '*.bak', '*.gz', 'Makefile.PL',
    ],
);

$build->create_build_script();
