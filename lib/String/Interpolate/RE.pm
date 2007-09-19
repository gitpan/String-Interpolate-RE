# --8<--8<--8<--8<--
#
# Copyright (C) 2007 Smithsonian Astrophysical Observatory
#
# This file is part of String::Interpolate::RE
#
# String::Interpolate::RE is free software: you can redistribute it
# and/or modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation, either version 3 of
# the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# -->8-->8-->8-->8--

package String::Interpolate::RE;

use strict;
use warnings;
use Carp;

use base 'Exporter';
our @EXPORT_OK = qw( strinterp );

our $VERSION = '0.02';

sub strinterp
{
  my ( $text, $var, $opts ) = @_;

  $var = {} unless defined $var;

  my %opt = ( raiseundef => 0,
	      emptyundef => 0,
	      useenv => 1,
	      defined $opts
	          ? ( map { (lc $_ => $opts->{$_ }) } keys %{$opts} )
	          : (),
	     );

  $text =~ s{
       \$                # find a literal dollar sign
      (                  # followed by either
       {(\w+)}           #   a variable name in curly brackets ($2)
       |                 # or
        (\w+)            #   a bareword ($3)
      )
  }{
      my $t = defined( $3 ) ? $3 : $2;

      # in user provided variable hash?
        defined $var->{$t}                ? $var->{$t}

      # maybe in the environment
      : $opt{useenv} && exists $ENV{$t}   ? $ENV{$t}

      # undefined: throw an error?
      : $opt{raiseundef}                  ? croak( "undefined variable: $t\n" )

      # undefined: replace with ''?
      : $opt{emptyundef}                  ? ''

      # just put it back into the string
      :                                     '$' . $1;
  }egx;

  return $text;
}

1;

__END__

=head1 NAME

String::Interpolate::RE - interpolate variables into strings


=head1 SYNOPSIS

    use String::Interpolate::RE qw( interpolate );

    $str = strinterp( "${Var1} $Var2", \%vars, \%opts );


=head1 DESCRIPTION

This module interpolates variables into strings, using the passed
C<%vars> hash as well as C<%ENV> as the source of the values.

It uses regular expression matching rather than Perl's built-in
interpolation mechanism and thus hopefully does not suffer from the
security problems inherent in using B<eval> to interpolate into
strings of suspect ancestry.


=head1 INTERFACE

=over

=item strinterp

    $str = strinterp( $template );
    $str = strinterp( $template, \%var );
    $str = strinterp( $template, \%var, \%opts );

Interpolate variables into a template string, returning the
resultant string.  The template string is scanned for tokens of the
form

    $VAR
    ${VAR}

where C<VAR> is composed of one or more word characters (as defined by
the C<\w> Perl regular expression pattern).  If a matching token is a
key in either the optional C<%var> hash or in the C<%ENV>
hash the corresponding value will be interpolated into the string at
that point.  REs which are not defined are by default left as is
in the string.

The C<%opts> parameter may be used to modify the behavior of this
function.  The following (case insensitive) keys are recognized:

=over

=item RaiseUndef

If true, a variable which has not been defined will result in an
exception being raised.  This defaults to false.

=item EmptyUndef

If true, a variable which has not been defined will be replaced with
the empty string.  This defaults to false.

=item UseENV

If true, the C<%ENV> hash will be searched for variables which are not
defined in the passed C<%var> hash.  This defaults to true.


=back

=back


=head1 DIAGNOSTICS

=over

=item C<< undefined variable: %s >>

This string is thrown if the C<RaiseUndef> option is set and the
variable C<%s> is not defined.

=back

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

Please report any bugs or feature requests to
C<bug-string-interpolate-re@rt.cpan.org>, or through the web interface at
L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=String-Interpolate-RE>.

=head1 SEE ALSO

Other CPAN Modules which interpolate into strings are
L<String::Interpolate> and L<Interpolate>.  This module avoids the use
of B<eval()> and presents a simpler interface.


=head1 VERSION

Version 0.01

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2007 The Smithsonian Astrophysical Observatory

String::Interpolate::RE is free software: you can redistribute
it and/or modify it under the terms of the GNU General Public License
as published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

=head1 AUTHOR

Diab Jerius  E<lt>djerius@cpan.orgE<gt>


