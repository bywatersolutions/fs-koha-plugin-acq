#! /usr/bin/perl
use MARC::Field;
use C4::Heading;
use C4::Context;
use C4::Biblio;

use Koha::Acquisition::Booksellers;
use Koha::Patrons;
use Koha::DateUtils qw(dt_from_string output_pref);

use Getopt::Long;
use Text::CSV_XS;

use open qw( :utf8 );

my $file;
GetOptions(
    "f|file=s" => \$file
);

my $lines;
open($lines, '< :encoding(UTF-8)', $file);
my $csv = Text::CSV_XS->new ({ binary => 1, decode_utf8 => 0 });
my %links;
my $dbh = C4::Context->dbh;

my $sth = $dbh->prepare(q|
    INSERT INTO koha_plugin_com_bywatersolutions_acqhistory_acqhistory 
    VALUES (?,?,?,?,?,?,?,?,?,?)
    |);


while ( my $line = $csv->getline($lines) ) {
my $date = undef;

if( $line->[19] ){
    my @csv_date = split(" ",$line->[19]);
    my @date = split("/",$csv_date[0]);
    my @time = split(":",$csv_date[1]);

    my $sql_date = $date[2] ."-";
    $sql_date .=  length($date[0])==2 ? $date[0] :"0".$date[0] ;
    $sql_date .= '-';
    $sql_date .= length($date[1])==2 ? $date[1] :"0".$date[1];
    $date=$sql_date;
}

#$line->[23] = "Rennells Antikvariat AB" if $line->[1] eq '545657';
#$line->[23] = "Dansk Historisk Handbogsforlag" if substr($line->[23],0,17) eq 'Dansk Historisk H';
#$line->[23] = "Osterreichisches Staatsarchiv" if substr($line->[23],1,28) eq 'sterreichisches Staatsarchiv';
#$line->[23] = "Verlag Fur Standesamtswesen" if substr($line->[23],9,18) eq 'r Standesamtswesen';
    $sth->execute(
        undef,
        $line->[1],
        $line->[0],
        undef,
        $line->[23],
        $date,
        $line->[20]?1:0,
        $line->[21]||undef,
        0,
        0,
    );
}

#printf '%04d-%02d-%02d %02d:%02d:%02d',$date[2],$date[1],$date[0],@time;
#$csv_date[0] = "0".$csv_date[0] if length( $csv_date[0] ) ==  9;
#warn Data::Dumper::Dumper( $csv_date[0] );
#my $date = dt_from_string( $csv_date[0] );
#warn output_pref({ dt => $date, dateformat => 'sql' });

1;

