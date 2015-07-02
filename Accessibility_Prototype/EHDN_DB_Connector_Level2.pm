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

sub mapTableData {
    # no sanity checking in here... there should be!
    my $excel = Spreadsheet::XLSX->new($db_file);
    my $sheet = shift (@{$excel -> {Worksheet}});
    
    my %CDEs = {
        'dc:id' => "",
        
        }
    
}
1;