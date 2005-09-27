package Tie::Sub;

use 5.006001;
use strict;
use warnings;
use Carp qw(croak);

require Tie::Scalar;
our @ISA = 'Tie::Scalar';

our $VERSION = '0.01';

my %sub; # object data encapsulated

sub TIEHASH
{ my $self;
  ($self = bless \$self, shift)->Config(@_);
  $self;
}

sub DESTROY {
  delete $sub{$_[0] || ''};
}

# configure
sub Config {
  # object, parameter
  my $self = shift;
  if (@_) {
    my $coderef = shift;
    ref $coderef eq 'CODE' or croak 'Reference on CODE expects.';
    $sub{$self} = $coderef;
  }
  $sub{$self};
}

# execute the sub
sub FETCH
{ # object, key
  my ($self, $key) = @_;
  $sub{$self} or croak 'Call of Config is necessary.';
  # Several parameters to sub will submit as reference on an array.
  $sub{$self}->(ref $key eq 'ARRAY' ? @{$key} : $key);
}

1;

__END__

=head1 NAME

Tie::Sub - Tying subroutine to a hash

=head1 SYNOPSIS

=head2 Sample 1: like function

 use strict;
 use warnings;

 use Tie::Sub;
 tie my %sub, 'Tie::Sub', sub{sprintf '%04d', shift};

 print "See $sub{4} digits.";
 # result:
 # 0004

=head2 Sample 2: like subroutine

 use strict;
 use warnings;

 use Tie::Sub;
 my %sub, 'Tie::Sub';
 # the other way to config later
 tied(%sub}->Config( sub{ [ map sprintf("%04d\n", $_), @_ ] } );

 print @{ $sub{[0..2]} };
 # result:
 # 0000
 # 0001
 # 0002

=head2 Read configuration

 my $config = tied(%sub)->Config();

=head2 Write configuration

 my $config = tied(%sub)->Config( sub{yourcode} );

=head1 DESCRIPTION

Subroutines don't have interpreted into strings.
The module ties a subroutine to a hash.
The subroutine is executed at fetch hash.
At long last this is the same, only the notation is shorter.

Alternative to C<"...@{[sub('abc')]}...">
or C<'...'.sub('abc').'...'>
write C<"...$sub{abc}...">.

Think about:

 use Tie::Sub;
 use Encode::Entities;
 tie my %encode_entities, 'Tie::Sub', sub{encode_entities shift);
 print <<EOT;
   <html>
   ...
   $encode{'<abc>'}
   ...
 EOT

Sometimes the subroutine expects more than 1 parameter.
Then submit a reference on an array as C<">hash keyC<">.
The tied sub will get the parameters as scalar or array.

Use any reference to give back more then 1 return value.
The caller get back this reference.
There is no way to return a list.

=head1 METHODS

=head2 TIEHASH

 use Tie::Sub;
 tie my %sub, 'Tie::Sub', sub{yourcode};

C<">TIEHASHC<"> ties your hash and set options defaults.

=head2 Config

C<">ConfigC<"> stores your own subroutine.

 tied(%sub)->Config(sub {yourcode});

The method calls croak, if the key is not a reference of C<">CODEC<">.

<">ConfigC<"> gives a code reference.

=head2 FETCH

Give your parameter as key of your hash.
C<">FETCHC<"> will run your tied sub and give back the returns of your sub.
Think about, return value can't be a list, but reference of such things.

 print $sub{param};

=head2 DESTROY

Free encapsulated object data.

=head1 SEE ALSO

Tie::Hash

=head1 AUTHOR

Steffen Winkler, E<cpan@steffen-winkler.de>;

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2005 by Steffen Winkler

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.6.1 or,
at your option, any later version of Perl 5 you may have available.

=cut