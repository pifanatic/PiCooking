package PiCooking::Controller::Login;
use Moose;
use namespace::autoclean;

=head1 NAME

PiCooking::Controller::Login - Catalyst Controller

=head1 DESCRIPTION

Handles the login process

=cut

BEGIN { extends "Catalyst::Controller"; }

=head1 METHODS

=head2 begin

Redirect to home page if user is already logged in

=cut

sub begin : Private {
    my ($self, $c) = @_;

    if ($c->user_exists) {
        $c->response->redirect(
            $c->uri_for($c->controller("Root")->action_for("index"))
        );
    }
}


=head2 index

The login routine

=cut

sub index : Path Args(0) {
    my ($self, $c) = @_;

    if ($c->req->method eq "POST") {
        my $username = $c->req->params->{username};
        my $password = $c->req->params->{password};

        if (!$username || !$password) {
            $c->res->status(400);
            return $c->stash({ error_msg => "Bitte Benutzernamen und Passwort eingeben." });
        }

        if (!$c->authenticate({ username => $username, password => $password })) {
            return $c->stash({ error_msg => "Benutzername oder Passwort falsch." });
        }

        $c->response->redirect(
            $c->uri_for($c->controller("Root")->action_for("index"))
        );
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
