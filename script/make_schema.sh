script/picooking_create.pl    \
    model                     \
    DB                        \
    DBIC::Schema              \
    PiCooking::Schema         \
    create=static             \
    use_moose=1               \
    overwrite_modifications=1 \
    skip_load_external=1      \
    dbi:SQLite:picooking.db   \
    on_connect_do="PRAGMA foreign_keys = ON"
