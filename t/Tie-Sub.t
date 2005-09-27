use 5.6.1;
use strict;
use warnings;
use Test::More tests => 7;
BEGIN { use_ok('Tie::Sub') }

use Tie::Sub;
print "# initiating dying, sub is missing\n";
{ eval {
    tie my %sub, 'Tie::Sub';
    undef = $sub{undef};
  };
  ok +($@ || '') =~ /\b\QCall of Config is necessary.\E/;
}
tie my %sub, 'Tie::Sub', sub{$_[0]+1};
print "# check function\n";
{ ok $sub{1} == 2;
}
print "# save and get back subroutine, use method Config\n";
{ my $sub = sub {
    my ($p1, $p2) = @_;
    [$p1, $p2];
  };
  tied(%sub)->Config($sub);
  my $cfg = tied(%sub)->Config();
  ok $cfg eq $sub;
};
print "# check subroutine 2 parmams, 2 returns\n";
{ my ($p1, $p2) = @{ $sub{[1, 2]} };
  ok $p1 eq '1' && $p2 eq '2';
}
print "# initiating dying by storing wrong reference\n";
{ eval { tied(%sub)->Config(undef) };
  my $error1 = $@ || '';
  eval { tied(%sub)->Config([]) };
  my $error2 = $@ || '';
  my $regex = qr/\b\QReference on CODE expects.\E/;
  ok $error1 =~ /$regex/ && $error2 =~ /$regex/;
}
print "# initiating dying by storing into tied hash\n";
{ eval { $sub{1} = 2 };
  my $error = $@ || '';
  ok $error =~ /\b\Qdoesn't define a STORE method\E\b/;
}