package RD_Connect_Common;

use strict;
use vars qw(@ISA @EXPORT);
use Exporter;

@ISA = qw( Exporter );

@EXPORT = qw(@CDE statement printResourceHeader printContainerHeader manageHEAD serializeThis readConfiguration);


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
    
    database:records

);

sub readConfiguration {
	open(IN, "configuration.txt") || die "can't open configuration $!\n";
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
