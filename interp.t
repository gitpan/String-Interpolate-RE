use String::Interpolate::RE qw( strinterp );

$ENV{c} = '33';
$DB::single=1;
strinterp( '$c/b' );
strinterp( 'a/$c/b' );
strinterp( 'a/$c' );
