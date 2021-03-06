use strict;
use warnings;
use FindBin;
use Test::More "no_plan";

BEGIN {
    require "$FindBin::Bin/../lib/inc.pl";
}



$mech->get_ok("/login");
$mech->content_contains("Einloggen");



$mech->submit_form((
        fields      => {},
    )
);
$mech->header_is(
    "Status",
    400,
    "no form-data is a Bad Request"
);
$mech->content_contains("Benutzername und Passwort erforderlich.");



$mech->submit_form((
        fields      => {
            password => "PASSWORD"
        },
    )
);
$mech->header_is(
    "Status",
    400,
    "no username is a Bad Request"
);
$mech->content_contains("Benutzername und Passwort erforderlich.");



$mech->submit_form((
        fields      => {
            username => "USERNAME"
        },
    )
);
$mech->header_is(
    "Status",
    400,
    "no password is a Bad Request"
);
$mech->content_contains("Benutzername und Passwort erforderlich.");



$mech->submit_form_ok({
        fields      => {
            username => "USERNAME",
            password => "PASSWORD"
        },
    }
);
$mech->content_contains("Benutzername oder Passwort falsch.");



$mech->submit_form((
        fields      => {
            username => "admin",
            password => "admin"
        },
    )
);

$mech->header_is(
    "Status",
    302,
    "redirects after successful login"
);

$mech->header_is(
    "Location",
    "http://localhost/",
    "redirects to '/' after successful login"
);



$mech->get("/login");

$mech->header_is(
    "Status",
    302,
    "redirects on GET /login when already logged in"
);

$mech->header_is(
    "Location",
    "http://localhost/",
    "redirects to '/'"
);
