#!/usr/bin/perl -w
package FAIR::Accessor;
use lib "../";
use base 'FAIR::AccessorBase';
#
#unless ($ENV{REQUEST_METHOD}){  # if running from command line
#        $ENV{REQUEST_METHOD} = "GET";
#        $ENV{'REQUEST_URI'} = "/this/thing";
#        $ENV{'SERVER_NAME'} = "example.net";
#	$ENV{'PATH_INFO'} = "/479-467-29X";
#}

sub handle_requests {

    my $self = shift;
    
    # THIS ROUTINE WILL BE SHARED BY ALL SERVERS
    if ($ENV{REQUEST_METHOD} eq "HEAD") {
        $self->manageHEAD();
        exit;
    } elsif ($ENV{REQUEST_METHOD} eq "OPTIONS"){
        $self->manageHEAD();
        exit;
    }  elsif ($ENV{REQUEST_METHOD} eq "GET") {
            if ($ENV{'PATH_INFO'}) {  # this will never happen with the minimal server
                    $self->printResourceHeader();
                    $self->manageResourceGET();
            } else {
                    $self->printContainerHeader();
                    $self->manageContainerGET();
            }
    } else {
        print "Status: 405 Method Not Allowed\n"; 
        print "Content-type: text/plain\n\nYou can only request HEAD, OPTIONS or GET from this LD Platform Server\n\n";
        exit 0;
    }

}








1;
