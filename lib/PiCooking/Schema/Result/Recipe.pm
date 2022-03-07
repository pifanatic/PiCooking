use utf8;
package PiCooking::Schema::Result::Recipe;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PiCooking::Schema::Result::Recipe

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 COMPONENTS LOADED

=over 4

=item * L<DBIx::Class::InflateColumn::DateTime>

=back

=cut

__PACKAGE__->load_components("InflateColumn::DateTime");

=head1 TABLE: C<Recipes>

=cut

__PACKAGE__->table("Recipes");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 title

  data_type: 'text'
  is_nullable: 0

=head2 ingredients

  data_type: 'text'
  is_nullable: 0

=head2 instructions

  data_type: 'text'
  is_nullable: 0

=head2 created

  data_type: 'date'
  is_nullable: 0

=head2 in_trash

  data_type: 'integer'
  default_value: 0
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "title",
  { data_type => "text", is_nullable => 0 },
  "ingredients",
  { data_type => "text", is_nullable => 0 },
  "instructions",
  { data_type => "text", is_nullable => 0 },
  "created",
  { data_type => "date", is_nullable => 0 },
  "in_trash",
  { data_type => "integer", default_value => 0, is_nullable => 0 },
  "user_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 recipes_categories

Type: has_many

Related object: L<PiCooking::Schema::Result::RecipesCategory>

=cut

__PACKAGE__->has_many(
  "recipes_categories",
  "PiCooking::Schema::Result::RecipesCategory",
  { "foreign.recipe_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 user

Type: belongs_to

Related object: L<PiCooking::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "PiCooking::Schema::Result::User",
  { id => "user_id" },
  { is_deferrable => 0, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07049 @ 2022-03-07 16:00:17
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:rIWNWmSd1NeqThqAGlRl5Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
