package PiCooking::Controller::Categories;
use Moose;
use namespace::autoclean;

=head1 NAME

PiCooking::Controller::Categories

=head1 DESCRIPTION

Handles all actions referring to categories.

=cut

BEGIN { extends "Catalyst::Controller"; }

=head1 METHODS

=head2 index

Retrieve all categories from the database and stash them in order to show a list
of all categories.

=cut

sub index : Path Args(0) {
    my ($self, $c) = @_;

    my @categories = $c->model("DB::Category")->search({ user_id => $c->user->id });

    $c->stash({
        categories => \@categories
    });
}

=head2 remove_unused_categories

Remove all categories that are not used by any recipe

=cut

sub remove_unused_categories : Private {
    my ($self, $c) = @_;

    my @categories = $c->model("DB::Category")->search({ user_id => $c->user->id });

    foreach my $category (@categories) {
        if ($category->recipes->count eq 0) {
            $category->delete;
        }
    }
}

__PACKAGE__->meta->make_immutable;

1;

=encoding utf8

=head1 AUTHOR

Kai Mörker

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
