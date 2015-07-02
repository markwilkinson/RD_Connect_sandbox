package RD_Connect_Common;

use strict;
use JSON;
use vars qw(@ISA @EXPORT);
use Exporter;

use URI::Escape;
use RDF::Trine;
use RDF::Trine::Node::Resource;
use RDF::Trine::Node::Literal;
use RDF::Trine::Statement;
use RDF::NS '20131205';              # check at compile time
use JSON;	


@ISA = qw( Exporter );

@EXPORT = qw(@CDE statement printResourceHeader printContainerHeader manageHEAD serializeThis readConfiguration $NS);

our $NS = RDF::NS->new('20131205'); 
die "can't set namespace $!\n" unless ($NS->SET(ldp => 'http://www.w3.org/ns/ldp#'));
die "can't set namespace $!\n" unless ($NS->SET(database => 'http://example.org/ns#'));
die "can't set namespace $!\n" unless ($NS->SET(daml => "http://www.ksl.stanford.edu/projects/DAML/ksl-daml-desc.daml#"));
die "can't set namespace $!\n" unless ($NS->SET(edam => "http://edamontology.org/"));
die "can't set namespace $!\n" unless ($NS->SET(sio => "http://semanticscience.org/resource/"));

# define the common data elements here, and their namespaces
our @CDE = qw(
    dcat:contactPoint
    dcat:description
    dcat:distribution
    dcat:frequency
    dcat:identifier
    dcat:keyword
    dcat:landingPage
    dcat:language
    dcat:publisher
    dcat:releaseDate
    dcat:spatialCoverage
    dcat:temporalCoverage
    dcat:theme
    dc:title
    dcat:updateDate
    void:entities
    daml:has-Technical-Lead
    daml:has-Administrative-Contact
    daml:has-Program-Manager
    daml:has-Principle-Investigator

);

sub readConfiguration {
	
#	open(IN, "configuration.txt") || die "can't open configuration $!\n";
	open(IN, "configuration2.txt") || die "can't open configuration $!\n";
	my %configuration;
	while (<IN>) {
		my ($key, $value) = split /\=/, $_;
		$key =~ s/\s//g;
		$value =~ s/#.*$//;
		$value =~ s/\s+$//;
		$value =~ s/^\s+//;
		$configuration{$key} = $value;	
	}
	return %configuration;
	
}

sub statement {
	my ($s, $p, $o) = @_;
	unless (ref($s) =~ /Trine/){
		$s =~ s/[\<\>]//g;
		$s = RDF::Trine::Node::Resource->new($s);
	}
	unless (ref($p) =~ /Trine/){
		$p =~ s/[\<\>]//g;
		$p = RDF::Trine::Node::Resource->new($p);
	}
	unless (ref($o) =~ /Trine/){

		if ($o =~ /^http\:\/\// || $o =~ /^https\:\/\//){
			$o = RDF::Trine::Node::Resource->new($o);
		} elsif ($o =~ /^<http\:\/\//){
			$o =~ s/[\<\>]//g;
			$o = RDF::Trine::Node::Resource->new($o);
		} elsif ($o =~ /"(.*?)"\^\^\<http\:/) {
			$o = RDF::Trine::Node::Literal->new($1);
		} else {
			$o = RDF::Trine::Node::Literal->new($o);				
		}
	}
	my $statement = RDF::Trine::Statement->new($s, $p, $o);
	return $statement;
}


sub printResourceHeader {
	my ($ETAG) = @_;
	my $entity = $ENV{'PATH_INFO'};
	$entity =~ s/^\///;
	print "Content-Type: text/turtle\n";
	print "ETag: \"$ETAG"."_"."$entity\"\n";
	print "Allow: GET,OPTIONS,HEAD\n";
	print 'Link: <http://www.w3.org/ns/ldp#Resource>; rel="type"'."\n\n";

}

sub printContainerHeader {
	my ($ETAG) = @_;
	print "Content-Type: text/turtle\n";
	print 'ETag: "MarksDemoEHDN_MinimalServerXXXXXX"'."\n";
	print "Allow: GET,OPTIONS,HEAD\n";
	print 'Link: <http://www.w3.org/ns/ldp#BasicContainer>; rel="type",'."\n";
	print '      <http://www.w3.org/ns/ldp#Resource>; rel="type"'."\n\n";
	#    print "Transfer-Encoding: chunked\n\n";

}

sub manageHEAD {
	my ($ETAG) = @_;
	
	print "Content-Type: text/turtle\n";
	print "ETag: \"$ETAG\"\n";
	print "Allow: GET,OPTIONS,HEAD\n\n";
	print 'Link: <http://www.w3.org/ns/ldp#BasicContainer>; rel="type",'."\n";
	print '      <http://www.w3.org/ns/ldp#Resource>; rel="type"'."\n\n";
    
}

sub serializeThis{
    my $model = shift;
    my $serializer = RDF::Trine::Serializer->new('turtle');
    print $serializer->serialize_model_to_string($model);
}
