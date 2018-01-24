#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;
use Test::Deep;
use File::Slurp;
use LWP::UserAgent;

use XML::LibXML;
XML::LibXML->new()->load_catalog('t/xml-catalog/catalog.xml');

use XML::LibXML::Ferry;
use Business::cXML;

use lib 't/';
use Test::cXML qw(comparable);

plan tests => 9;

my $cxml = Business::cXML->new(
#	log_level => CXML_LOG_WARNING,
);

sub _testify {
	my ($msg) = @_;
	$msg->from(id => 'remotehost', domain => 'TEST');
	$msg->to(  id => 'localhost',  domain => 'TEST');
	$msg->xml_payload->add('BuyerCookie', '12345678');
	$msg->xml_payload->add('PunchOutOrderMessageHeader', undef,
		operationAllowed => 'create',
		quoteStatus      => 'final',
	)->add('Total')->add('Money', '12.99', currency => 'CAD');
}

my $msg = $cxml->new_message('PunchOutOrder');
_testify($msg);
cmp_deeply(
	comparable(XML::LibXML->load_xml(string => scalar($msg->toString))),
	comparable(XML::LibXML->load_xml(location => 't/xml-assets/punchoutorder-message.xml')),
	'Profile request matches expectations'
);

my $b64 = ($cxml->stringify($msg) =~ s/^.*name="cxml-base64"\s+value="([^"]*)".*$/$1/sr);
cmp_deeply(
	comparable(XML::LibXML->load_xml(string => scalar(Business::cXML::Transmission->new($b64)->toString))),
	comparable(XML::LibXML->load_xml(location => 't/xml-assets/punchoutorder-message.xml')),
	'Base64-XML round-trip as expected'
);

$msg = $cxml->new_message();
$msg->type('PunchOutOrder');
_testify($msg);
cmp_deeply(
	comparable(XML::LibXML->load_xml(string => scalar(Business::cXML::Transmission->new($b64)->toString))),
	comparable(XML::LibXML->load_xml(location => 't/xml-assets/punchoutorder-message.xml')),
	'Alternative Base64-XML round-trip as expected'
);

ok($cxml->stringify($msg, url           => 'MYURL'      ) =~ /action="MYURL"/s,        'URL reaches form as action'   );
ok($cxml->stringify($msg, submit_button => '<MYBUTTON/>') =~ /><MYBUTTON\/><\/form>/s, 'Submit button can be replaced');
ok($cxml->stringify($msg, target        => 'MYTARGET'   ) =~ /\s+target="MYTARGET">/s, 'Target reaches form'          );

$msg->xml_payload->add('GarbageElement', 'This triggers validation error');
cmp_deeply($cxml->stringify($msg), '', 'Invalid XML produces empty string.');

cmp_deeply(
	comparable(XML::LibXML->load_xml(string => scalar(Business::cXML::Transmission->new(scalar(read_file('t/xml-assets/punchoutorder2-message.xml')))->toString))),
	comparable(XML::LibXML->load_xml(location => 't/xml-assets/punchoutorder2-message.xml')),
	'Alternate XML round-trip as expected'
);

cmp_deeply(
	comparable(XML::LibXML->load_xml(string => scalar(Business::cXML::Transmission->new(scalar(read_file('t/xml-assets/punchoutorder3-message.xml')))->toString))),
	comparable(XML::LibXML->load_xml(location => 't/xml-assets/punchoutorder3-message.xml')),
	'XML round-trip with non-OK status is as expected'
);

