=encoding utf-8

=head1 NAME

Business::cXML::ItemIn - cXML line item, from seller to buyer

=head1 SYNOPSIS

	use Business::cXML::ItemIn;

=head1 DESCRIPTION

Object representation of cXML C<ItemIn>.

=head1 METHODS

See L<Business::cXML::Object/COMMON METHODS>.

=head1 PROPERTY METHODS

See L<Business::cXML::Object/PROPERTY METHODS> for how the following operate.

=over

=cut

use 5.006;
use strict;

package Business::cXML::ItemIn;
use base qw(Business::cXML::Object);

use constant PROPERTIES => (
	id                => undef,
	qty               => 0,
	qty_open          => undef,
	qty_promised      => undef,
	i                 => undef,
	i_parent          => undef,
	is_group          => undef,
	is_parent_group   => undef,
	is_service        => undef,
	amount_unit       => undef,
	descriptions      => [],
	unit              => 'EA',
	manufacturer_part => undef,
	manufacturer      => undef,
	delay             => undef,
	characteristics   => [],
	url               => undef,
	amount_shipping   => undef,
	amount_tax        => undef,
);
use constant OBJ_PROPERTIES => (
	id              => 'Business::cXML::ItemID',
	amount_unit     => 'Business::cXML::Amount',
	descriptions    => 'Business::cXML::Description',
	amount_shipping => 'Business::cXML::Amount',
	amount_tax      => 'Business::cXML::Amount',
);

use XML::LibXML::Ferry;

sub _bool {
	my ($self, $val) = @_;
	return 1 if $val =~ /^(composite|groupLevel|service)$/;
	return 0 if $val =~ /^(item|itemLevel|material)$/;
	return undef;
}

sub _characteristic {
	my ($self, $val) = @_;
	return {
		domain => $val->{domain},
		value  => $val->{value},
		code   => $val->{code},
	};
}

sub from_node {
	my ($self, $el) = @_;

	$el->ferry($self, {
		quantity           => 'qty',
		openQuantity       => 'qty_open',
		promisedQuantity   => 'qty_promised',
		lineNumber         => 'i',
		parentLineNumber   => 'i_parent',
		itemType           => [ 'is_group',        \&_bool ],
		compositeItemType  => [ 'is_parent_group', \&_bool ],
		itemClassification => [ 'is_service',      \&_bool ],
		itemCategory       => '__UNIMPLEMENTED',
		ItemID       => [ 'id', 'Business::cXML::ItemID' ],
		Path         => '__UNIMPLEMENTED',
		ItemDetail   => {
			UnitPrice             => [ 'amount_unit',  'Business::cXML::Amount'      ],
			Description           => [ 'descriptions', 'Business::cXML::Description' ],
			OverallLimit          => '__UNIMPLEMENTED',
			ExpectedLimit         => '__UNIMPLEMENTED',
			UnitOfMeasure         => 'unit',
			PriceBasisQuantity    => '__UNIMPLEMENTED',
			Classification        => '__UNIMPLEMENTED',  # TODO: we need it, see www.unspsc.org
			ManufacturerPartID    => 'manufacturer_part',
			ManufacturerName      => 'manufacturer',  # UNIMPLEMENTED attribute xml:lang
			# URL is implicit
			LeadTime              => 'delay',
			Dimension             => '__UNIMPLEMENTED',
			ItemDetailIndustry    => {
				# Attribute isConfigurableMaterial is implied from the presence of characteristics
				ItemDetailRetail => {
					EANID                  => '__OBSOLETE',
					EuropeanWasteCatalogID => '__UNIMPLEMENTED',
					Characteristic         => [ 'characteristics', \&_characteristic ],
				},
			},
			AttachmentReference   => '__UNIMPLEMENTED',
			PlannedAcceptanceDays => '__UNIMPLEMENTED',
		},
		SupplierID   => '__UNIMPLEMENTED',
		SupplierList => '__UNIMPLEMENTED',
		ShipTo       => '__UNIMPLEMENTED',
		Shipping     => [ 'amount_shipping', 'Business::cXML::Amount' ],
		Tax          => [ 'amount_tax',      'Business::cXML::Amount' ],
		SpendDetail  => '__UNIMPLEMENTED',
		Distribution => '__UNIMPLEMENTED',
		Contact      => '__UNIMPLEMENTED',
		Comments     => '__UNIMPLEMENTED',
		ScheduleLine => '__UNIMPLEMENTED',
		BillTo       => '__UNIMPLEMENTED',
		Batch        => '__UNIMPLEMENTED',
		DateInfo     => '__UNIMPLEMENTED',  # TODO: are we sure we don't want this?
	});
}

sub to_node {
	my ($self, $doc) = @_;
	#return $node;
}

=item C<B<unit>>

Mandatory, UN/CEFACT Recommendation 20 unit of measure.  Default: C<EA>
meaning "each", items are regarded as separate units.

See
L<http://www.unece.org/tradewelcome/un-centre-for-trade-facilitation-and-e-business-uncefact/outputs/cefactrecommendationsrec-index/list-of-trade-facilitation-recommendations-n-16-to-20.html>
for more details about UN/CEFACT Recommendation 20 units of measure.

=back

=head1 AUTHOR

Stéphane Lavergne L<https://github.com/vphantom>

=head1 ACKNOWLEDGEMENTS

Graph X Design Inc. L<https://www.gxd.ca/> sponsored this project.

=head1 COPYRIGHT & LICENSE

Copyright (c) 2017-2018 Stéphane Lavergne L<https://github.com/vphantom>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
=cut

1;
