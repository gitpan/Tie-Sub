#perl -T

use strict;
use warnings;

use Test::More tests => 9;

BEGIN {
    use_ok('Tie::Sub');
}

# tie only
my $object = tie my %sub, 'Tie::Sub';
isa_ok(
    $object,
    'Tie::Sub',
);

# not configured
eval {
    () = $sub{undef};
};
like(
    $@,
    qr{\b \QCall of method "Config" is necessary\E \b}xms,
    'initiating dying if sub is missing',
);

# false configuration
eval {
    $object->Config(undef);
};
like(
    $@,
    qr{\Q'undef'\E}xms,
    'initiating dying by configure wrong reference',
);
eval {
    $object->Config([]);
};
my $error2 = $@ || q{};
like(
    $@,
    qr{\Q'arrayref'\E}xms,
    'initiating dying by configure wrong reference',
);

# read back no configuration
ok(
    ! defined $object->Config(),
    'read back no configuration',
);
my $sub1 = sub {};
ok(
    ! defined $object->Config($sub1),
    'read back no configuration after config a new',
);

# read back true configuration
my $sub2 = sub {return shift};
cmp_ok(
    $object->Config($sub2),
    'eq',
    $sub1,
    'configurate a new subroutine and get back the previous subroutine',
);

# test not implemented method
eval {
    $sub{1} = 2;
};
like(
    $@,
    qr{\b STORE \b}xms,
    'initiating dying by storing into tied hash',
);
