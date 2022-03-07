package PiCooking::Model::DB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'PiCooking::Schema',

    connect_info => {
        dsn            => 'dbi:SQLite:picooking.db',
        user           => '',
        password       => '',
        on_connect_do  => q{PRAGMA foreign_keys = ON},
        sqlite_unicode => 1
    }
);

=head1 NAME

PiCooking::Model::DB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<PiCooking>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<PiCooking::Schema>


=head1 METHODS

=head2 create_recipe

Creates a new recipe in the database.

Returns the newly created recipe

=cut

sub create_recipe {
    my ($self, $args) = @_;

    my @categories = @{ $args->{categories} };

    my $new_recipe = $self->resultset("Recipe")->create({
        title        => $args->{title},
        ingredients  => $args->{ingredients},
        instructions => $args->{instructions},
        created      => DateTime->today->iso8601,
        user_id      => $args->{user_id}
    });

    if (@categories > 0) {
        @categories = map {
            $self->resultset("Category")->find_or_create({
                name    => $_,
                user_id => $args->{user_id}
            });
        } @categories;

        $new_recipe->set_categories(@categories);
    }

    return $new_recipe;
}


=head2 update_recipe

Update the I<title>, I<ingredients>, I<instructions> and I<categories>
attributes of a given recipe.

Returns the updated recipe.

=cut

sub update_recipe {
    my ($self, $recipe, $args) = @_;

    my @categories = @{ $args->{categories} };

    $recipe->update({
        title        => $args->{title},
        ingredients  => $args->{ingredients},
        instructions => $args->{instructions}
    });

    $recipe->recipes_categories->delete;

    if (@categories > 0) {
        @categories = map {
            $self->resultset("Category")->find_or_create({
                name    => $_,
                user_id => $args->{user_id}
            });
        } @categories;

        $recipe->set_categories(@categories);
    }

    return $recipe;
}

=head1 AUTHOR

Kai

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
