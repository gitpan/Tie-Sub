#perl -T

use strict;
use warnings;

use Test::More tests => 3 + 1;
use Test::Exception;
use Test::NoWarnings;

BEGIN {
    use_ok('Tie::Sub');
}

# tie only
my $object = tie my %sub, 'Tie::Sub';
isa_ok(
    $object,
    'Tie::Sub',
);

lives_ok(
    sub {
        $object->Config( sub{} );
    },
    'Call method "Config"',
);
