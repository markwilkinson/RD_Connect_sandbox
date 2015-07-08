 #!/usr/bin/env perl
        use strict;
        use warnings;
        use Spreadsheet::XLSX::Reader::LibXML;
my $workbook;
        my $parser   = Spreadsheet::XLSX::Reader::LibXML->new();
#        $workbook = $parser->parse( '/home/markw/.cpan/build/Spreadsheet-XLSX-Reader-LibXML-v0.38.6-PIVygW/t/test_files/TestBook.xlsx' );
#        $workbook = $parser->parse( 'registry3-comorbid.xlsx.xlsx' );
        $workbook = $parser->parse( 'test2.xlsx' );

        if ( !defined $workbook ) {
                die $parser->error(), "\n";
        }
