package Koha::Plugin::Com::ByWaterSolutions::AcqHistory::Controller;

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# This program comes with ABSOLUTELY NO WARRANTY;

use Modern::Perl;

use Mojo::Base 'Mojolicious::Controller';
use Mojo::JSON qw(decode_json);
use Encode qw(encode_utf8);

use CGI;
use Try::Tiny;


sub get_title_history {
    my $c = shift->openapi->valid_input or return;

    my $biblionumber = $c->validation->param('title_no');

    return try {
        my $dbh = C4::Context->dbh;

        my $query = q|
            SELECT * FROM koha_plugin_com_bywatersolutions_acqhistory_acqhistory
            WHERE title_no = ?
        |;

        my $sth = $dbh->prepare($query);
        $sth->execute($biblionumber);

        my $row = $sth->fetchall_arrayref();


        return $c->render(
            status  => 200,
            openapi => $row
        );
    }
    catch {
        $c->unhandled_exception($_);
    };
}

sub get_vendor_history {
    my $c = shift->openapi->valid_input or return;

    my $supplier_id = $c->validation->param('supplier_id');

    return try {
        my $dbh = C4::Context->dbh;

        my $query = q|
            SELECT * FROM koha_plugin_com_bywatersolutions_acqhistory_acqhistory
            WHERE supplier_id = ?
        |;

        my $sth = $dbh->prepare($query);
        $sth->execute($supplier_id);

        my $row = $sth->fetchall_arrayref();


        return $c->render(
            status  => 200,
            openapi => $row
        );
    }
    catch {
        $c->unhandled_exception($_);
    };
}
