use strict;
use warnings;
use FindBin;
use Test::More "no_plan";

BEGIN {
    require "$FindBin::Bin/../../lib/inc.pl";
}



my $tx;

$mech->get("/recipes");

$mech->header_is(
    "Status",
    302,
    "redirects when accessing /recipes without login"
);

$mech->header_is(
    "Location",
    "http://localhost/login",
    "redirects to login when access /recipes without login"
);



$mech->get("/login");

$mech->submit_form((
        fields      => {
            username => "admin",
            password => "admin"
        },
    )
);



$mech->get_ok(
    "/recipes",
    "can GET /recipes when logged in"
);
