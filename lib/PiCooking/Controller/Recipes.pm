package PiCooking::Controller::Recipes;
use Moose;
use namespace::autoclean;

use DateTime;

=head1 NAME

PiCooking::Controller::Recipes

=head1 DESCRIPTION

Handles all actions referring to recipes.

=cut

BEGIN { extends "Catalyst::Controller"; }

=head1 METHODS

=head2 index

Retrieve all recipes from the database and stash them in order to show a list of
all recipes.

Show only recipes with a specific category if the I<category> URL parameter is given.

=cut

sub index : Path Args(0) {
    my ($self, $c) = @_;

    my $category = $c->req->params->{category};

    $c->forward($self->action_for("get_recipes"));

    if ($category) {
        $c->stash->{recipes_rs} = $c->stash->{recipes_rs}->search(
            {
                "category.name" => $category
            },
            {
                join     => { recipes_categories => { category => "recipes_categories" } },
                collapse => 1
            }
        );

        $c->stash({ category => $category });
    }

    $c->stash({ recipes => [$c->stash->{recipes_rs}->all] });
}


=head2 add

GET shows a form to enter all values for a new recipe.

POST creates a new recipe in the database with the given form-data.

=cut

sub add : Local Args(0) {
    my ($self, $c) = @_;

    if ($c->req->method eq "POST") {
        my $new_recipe = $c->model("DB")->create_recipe({
            title        => $c->req->params->{title},
            ingredients  => $c->req->params->{ingredients},
            instructions => $c->req->params->{instructions},
            categories   => [split "\r\n", $c->req->params->{categories} ],
            user_id      => $c->user->id
        });

        $c->response->redirect($c->uri_for(
            $c->controller->action_for("add"),
            { mid => $c->set_status_msg('"' . $new_recipe->title . '" wurde erstellt!') }
        ));
    }
}


=head2 get_recipe_by_id

The base action for all actions that manipulate one single existing recipe.

This action searches for a specific recipe by its id and stashes it if it could
be found, and goes to the default 404 page if it could not be found.

=cut

sub get_recipe_by_id : Chained("/") PathPart("recipes") CaptureArgs(1) {
    my ($self, $c, $id) = @_;

    my $recipe = $c->model("DB::Recipe")->search({
        id      => $id,
        user_id => $c->user->id,
    })->first;

    if (!$recipe) {
        $c->go($c->controller("Root")->action_for("default"));
    }

    $c->stash({ recipe => $recipe });
}

=head2 view

Show all information about a recipe.

=cut

sub view : Chained("get_recipe_by_id") PathPart("") { }


=head2 edit

Changes the I<title>, I<ingredients>, I<instructions> or I<categories> of a
recipe.

GET shows a form filled with the current values of this recipe in order to
change them.

POST will update the values of the recipe with the given form-data and redirect
to the 'edit' page with the updated value afterwards.

=cut

sub edit : Chained("get_recipe_by_id") Args(0) {
    my ($self, $c) = @_;

    if ($c->req->method eq "POST") {
        $c->stash->{recipe} = $c->model("DB")->update_recipe(
            $c->stash->{recipe},
            {
                title        => $c->req->params->{title},
                ingredients  => $c->req->params->{ingredients},
                instructions => $c->req->params->{instructions},
                categories   => [ split "\r\n", $c->req->params->{categories} ],
                user_id      => $c->user->id
            }
        );

        my $status_msg = '"' . $c->stash->{recipe}->title .
                         '" wurde erfolgreich bearbeitet!';

        $c->forward($c->controller("Categories")->action_for("remove_unused_categories"));

        $c->response->redirect(
            $c->uri_for(
                $c->controller->action_for("view"),
                [ $c->stash->{recipe}->id ],
                { mid => $c->set_status_msg($status_msg) }
            )
        );
    }

    $c->stash({
        categories => join("\n", map { $_->name } $c->stash->{recipe}->categories)
    });
}


=head2 search

Search for recipes whose title/ingredients/instructions match a given query
string

=cut

sub search : Local Args(0) {
    my ($self, $c) = @_;

    my @recipes;
    my $query = $c->req->query_parameters->{q};

    if ($query) {
        @recipes = $c->model("DB::Recipe")->search({
            -or => {
                title        => { "like" => "%$query%" },
                instructions => { "like" => "%$query%" },
                ingredients  => { "like" => "%$query%" },
            },
            in_trash => 0,
            user_id  => $c->user->id
        });
    }

    $c->stash({
        query   => $query,
        recipes => \@recipes
    });
}

=head2 trash

Move a recipe to trash and return to the recipe list

=cut

sub trash : Chained("get_recipe_by_id") Args(0) {
    my ($self, $c) = @_;

    $c->stash->{recipe}->update({
        in_trash => 1
    });

    my $status_msg = '"' . $c->stash->{recipe}->title .
                     '" wurde in den Papierkorb verschoben';

    $c->response->redirect(
        $c->uri_for(
            $self->action_for("index"),
            { mid => $c->set_status_msg($status_msg) }
        )
    );
}

=head2 restore

Restores a recipe that had been moved to trash

=cut

sub restore : Chained("get_recipe_by_id") Args(0) {
    my ($self, $c) = @_;

    if ($c->stash->{recipe}->in_trash ne 1) {
        my $error_msg = "Konnte Rezept nicht wiederherstellen!";

        $c->response->redirect(
            $c->uri_for(
                $self->action_for("index"),
                { mid => $c->set_error_msg($error_msg) }
            )
        );

        $c->detach;
    } else {
        $c->stash->{recipe}->update({ in_trash => 0 });

        my $status_msg = "'" . $c->stash->{card}->title .
                         "' wurde wiederhergestellt!";

        $c->response->redirect(
            $c->uri_for(
                $c->controller("Trash")->action_for("index"),
                { mid => $c->set_status_msg($status_msg) }
            )
        );
    }
}

=head2 delete

Delete a recipe permanently

=cut

sub delete : Chained("get_recipe_by_id") Args(0) {
    my ($self, $c) = @_;

    $c->stash->{recipe}->delete;

    $c->forward($c->controller("Categories")->action_for("remove_unused_categories"));

    my $status_msg = "'" . $c->stash->{recipe}->title . "' wurde gelöscht!";

    $c->response->redirect(
        $c->uri_for(
            $c->controller("Trash")->action_for("index"),
            { mid => $c->set_status_msg($status_msg) }
        )
    );
}


=head2 get_recipes

Gets a resultset for all recipes of the current user that are not in trash

=cut

sub get_recipes : Private {
    my ($self, $c) = @_;

    my $recipes_rs = $c->model("DB::Recipe")->search({
        in_trash     => 0,
        "me.user_id" => $c->user->id
    });

    $c->stash({ recipes_rs => $recipes_rs });
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
