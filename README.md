# Installation

## Dependencies

All required dependencies for PiCooking are listed in `Makefile.PL`. In order to
install these you can run

```
    $ perl Makefile.PL
    $ make
    $ make test
    $ make install
```

**Note:** To get the full Catalyst experience during the development process
you should also install `Catalyst::Devel`. See the [docs](https://metacpan.org/pod/Catalyst::Devel)
for more information.

## Database initialization

PiCooking uses a SQLite database to store its recipes so make sure you have sqlite3
installed. If this is the case you can simply run

```
    $ script/create_db.sh
```

to generate a new SQLite database that contains all necessary tables for
PiCooking to work.

## Create a user

Use the provided `create_user.pl` script to create a user for the application:

```
    $ script/create_user.pl
```

## Start the server

```
    $ script/picooking_server.pl
```
