use strict;
use warnings;
use Template;
use Test::More tests => 4;
use Template::Plugin::Page;

my @expected_scalars = (

<<'END',


Showing page number 1 of 2

    letter: a

    letter: b

END

<<'END',


Showing page number 2 of 2

    letter: c

END

);


my @expected_hash = (

<<'END',


Showing page number 1 of 2

    letter: a

    letter: b

END

<<'END',


Showing page number 2 of 2

    letter: c

END

);

is process_scalars(1), $expected_scalars[0];
is process_scalars(2), $expected_scalars[1];

is process_hash(1), $expected_hash[0];
is process_hash(2), $expected_hash[1];

sub process_hash {
	my(%tag, $i, @data );
	for( 'a' .. 'c' ) {
		push @data, { letter => $_,  };
	}
	$tag{data} = \@data;
	$tag{pageno} = shift;
	my $tt = Template->new();
	my $data = get_template_hash();
	my $out;
	$tt->process( \$data, \%tag, \$out);
	return $out;
}

sub get_template_hash {
	return <<'END_TEMPLATE';
[% USE page = Page( data.size, 2, pageno)  %]
[% results = page.splice( data ) %]
Showing page number [% pageno %] of [% page.last_page %]
[% FOREACH item IN results %]
    letter: [% item.letter %]
[% END %]
END_TEMPLATE
}


sub process_scalars {
	my(%tag, $i, @data );
	@data = ('a' .. 'c' );
	$tag{data} = \@data;
	$tag{pageno} = shift;
	my $tt = Template->new(); 
	my $data = get_template_scalar();
	my $out;
	$tt->process( \$data, \%tag, \$out);
	return $out;
}

sub get_template_scalar {
	return <<'END_TEMPLATE';
[% USE page = Page( data.size, 2, pageno)  %]
[% results = page.splice( data ) %]
Showing page number [% pageno %] of [% page.last_page %]
[% FOREACH item IN results %]
    letter: [% item %]
[% END %]
END_TEMPLATE
}
