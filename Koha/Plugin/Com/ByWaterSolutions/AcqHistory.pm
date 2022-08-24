package Koha::Plugin::Com::ByWaterSolutions::AcqHistory;

use Modern::Perl;
use JSON qw(decode_json);

use C4::Installer qw(TableExists);


use base qw(Koha::Plugins::Base);

## Here we set our plugin version
our $VERSION         = "{VERSION}";
our $MINIMUM_VERSION = "21.11.00";

## Here is our metadata, some keys are required, some are optional
our $metadata = {
    name            => 'Acq History Plugin',
    author          => 'Nick Clemens',
    date_authored   => '2022-08-23',
    date_updated    => "1900-01-01",
    minimum_version => $MINIMUM_VERSION,
    maximum_version => undef,
    version         => $VERSION,
    description =>
      'This plugin adds the ability to view imported acquisition history in Koha.',
};


sub new {
    my ( $class, $args ) = @_;

    ## We need to add our metadata here so our base class can access it
    $args->{'metadata'} = $metadata;
    $args->{'metadata'}->{'class'} = $class;

    ## Here, we call the 'new' method for our base class
    ## This runs some additional magic and checking
    ## and returns our actual $self
    my $self = $class->SUPER::new($args);

    return $self;
}

sub install {
    my ( $self, $args ) = @_;
    my $dbh = C4::Context->dbh;

    my $ah_table = $self->get_qualified_table_name('acqhistory');
    unless( TableExists( $ah_table ) ){
        $dbh->do( "
            CREATE TABLE `$ah_table` (
                order_no INT(11) NULL,
                barcode VARCHAR(32) NULL,
                title_no INT(11) NULL,
                supplier_id INT(11) NULL,
                supplier_name LONGTEXT NULL,
                received_on date DEFAULT NULL,
                gift TINYINT(1) DEFAULT NULL,
                order_item_no INT(11) DEFAULT NULL,
                price DECIMAL(28,2) DEFAULT NULL,
                total_cost DECIMAL(28,2) DEFAULT 0
            ) ENGINE = INNODB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
        " );
    }

}

sub upgrade {
    my ( $self, $args ) = @_;

    return 1;
}

sub uninstall() {
    my ( $self, $args ) = @_;

    return 1;
}

sub intranet_js {
    my ( $self ) = @_;

    return q|
        <script src="/api/v1/contrib/acqhistory/static/js/biblio_details.js"></script>
        <script src="/api/v1/contrib/acqhistory/static/js/vendor_details.js"></script>
        <script src="/api/v1/contrib/acqhistory/static/js/item_details.js"></script>
    |;
}

sub api_routes {
    my ( $self, $args ) = @_;

    my $acq_spec_str = $self->mbf_read('openapi.json');
    my $spec     = { %{decode_json($acq_spec_str)} };

    return $spec;
}

sub static_routes {
    my ( $self, $args ) = @_;

    my $spec_str = $self->mbf_read('staticapi.json');
    my $spec     = decode_json($spec_str);

    return $spec;
}

sub api_namespace {
    my ($self) = @_;

    return 'acqhistory';
}

1;
