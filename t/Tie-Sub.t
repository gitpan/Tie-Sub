use 5.6.1;
use strict;
use warnings;
use Test::More tests => 7;
BEGIN { use_ok('Tie::Sub') }

{ eval {
    tie my %sub, 'Tie::Sub';
    undef = $sub{undef};
  };
  ok
    +($@ || '') =~ /\b\QCall of Config is necessary.\E/,
    'initiating dying, sub is missing'
  ;
}
tie my %sub, 'Tie::Sub', sub{$_[0]+1};
{ ok
    $sub{1} == 2,
    'check function'
  ;
}
{ my $sub = sub {
    my ($p1, $p2) = @_;
    [$p1, $p2];
  };
  tied(%sub)->Config($sub);
  my $cfg = tied(%sub)->Config();
  ok
    $cfg eq $sub,
    'save and get back subroutine, use method Config'
  ;
}
{ my ($p1, $p2) = @{ $sub{[1, 2]} };
  ok
    $p1 eq '1'
    && $p2 eq '2',
    'check subroutine 2 parmams, 2 returns'
  ;
}
{ eval { tied(%sub)->Config(undef) };
  my $error1 = $@ || '';
  eval { tied(%sub)->Config([]) };
  my $error2 = $@ || '';
  my $regex = qr/\b\QReference on CODE expects.\E/;
  ok
    $error1 =~ /$regex/
    && $error2 =~ /$regex/,
    'initiating dying by configure wrong reference'
  ;
}
{ eval { $sub{1} = 2 };
  my $error = $@ || '';
  ok
    $error =~ /\bSTORE\b/,
    'initiating dying by storing into tied hash'
  ;
}