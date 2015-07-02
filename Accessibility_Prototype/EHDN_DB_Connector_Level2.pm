package EHDN_DB_Connector_Level2;
use strict;
use JSON;
use Spreadsheet::XLSX;
use RD_Connect_Common;

my $db_file = "registry3-comorbid.xlsx.xlsx";  # maybe this should go in the configuration file... but it wont always be a file, e.g for real db connections

    
# CommonDataElements to be filled-in if possible (canonical list to be determined by the other work groups)
    #    dcat:contactPoint
    #dcat:description
    #dcat:distribution 
    #dcat:frequency
    #dcat:identifier
    #dcat:keyword
    #dcat:landingPage
    #dcat:language
    #dcat:publisher
    #dcat:releaseDate
    #dcat:spatialCoverage
    #dcat:temporalCoverage
    #dcat:theme
    #dc:title
    #dcat:updateDate
    #void:entities
    #daml:has-Technical-Lead
    #daml:has-Administrative-Contact
    #daml:has-Program-Manager
    #daml:has-Principle-Investigator

sub getMetadata {  # I'm making this up, but a real provider would know the real information

    my %result;
    
    $result{'dcat:landingPage'} = "http://www.euro-hd.net/html/network";
    
    my $theme = [qw(OMIM:143100 ORPHA:399 HGNC:HTT)];
    $result{'dcat:theme'} = $theme;
    $result{'dcat:description'} = "The European Huntington disease network database";
    $result{'dcat:keywords'} = ['HTT', 'huntington disease', 'huntingtin', 'rare disease'];
    $result{'dcat:publisher'} = 'http://www.euro-hd.net',
    $result{'dcat:updateDate'} = "1-7-2015";
    $result{'dcat:contactPoint'} = 'info@euro-hd.net';
    $result{'daml:has-Technical-Lead'} =  "Important Person";
    $result{'daml:has-Administrative-Contact'} = "Even more Important Person";
    $result{'daml:has-Principle-Investigator'} =  "Person With Money";
    $result{'void:entities'} = countRecords();
    $result{'database:records'} = getRecordIds();
    my $response  = encode_json(\%result);
    
    return $response;
    
}
  
sub connectToTable {
    # no sanity checking in here... there should be!
    my $excel = Spreadsheet::XLSX->new($db_file);
    my $sheet = shift (@{$excel -> {Worksheet}});
    return $sheet;
}

sub countRecords {
    # no sanity checking in here... there should be!
    my $sheet = connectToTable();
    my $rows = $sheet -> {MaxRow};
    return $rows;    
}

sub getRecordIds {
    my $sheet = connectToTable();
    my @ids;
    for (my $i=1; $i <= $sheet->{MaxRow}; $i++){
        push @ids, $sheet->{Cells}[$i][0]->{Val};
    }
    return \@ids;
}

sub getData {
    my ($self, $record) = @_;
    # no sanity checking in here... there should be!
    my $excel = Spreadsheet::XLSX->new($db_file);
    my $sheet = shift (@{$excel -> {Worksheet}});
    my %metadata;
    foreach my $row ($sheet -> {MinRow} .. $sheet -> {MaxRow}) {
        
        next unless $sheet -> {Cells} [$row][0]->{Val} eq $record;

        my $cell = $sheet -> {Cells} [$row] [5];
          $metadata{'dcat:updateDate'} = $cell->{Val};

        $cell = $sheet -> {Cells} [$row] [1];
          $metadata{'dcat:releaseDate'} = $cell->{Val};
          
        $cell = $sheet -> {Cells} [$row] [3];
          $metadata{'database:enrollmentState'} = $cell->{Val};

          last;
    }
    my $response  = encode_json(\%metadata);
    
    return $response;
#subject	created	site	subject_state	visit	svstdtc	visit_state	visit_id	nr	enr	mhterm__term	mhterm__modify	mhterm__decod	mhterm__certainty	mhbodsys	mhstdtc	mhenrf	mhendtc	mhscat
#479-467-29X	13-Feb-15	test	violator	General	13-Feb-15	signed	61499	1	1	Tension-type headache	Tension-type headache	G44.2	manual	3	1996	1		4
#768-599-467	5-Aug-13	test	enrolled	General	5-Aug-13	signed	46200	1	1	Allergic rhinitis due to pollen	Allergic rhinitis due to pollen	J30.1	manual	13	2000	1		6
    
}
1;