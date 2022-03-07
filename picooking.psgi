use strict;
use warnings;

use PiCooking;

my $app = PiCooking->apply_default_middlewares(PiCooking->psgi_app);
$app;
