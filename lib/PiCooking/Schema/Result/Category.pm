use utf8;
package PiCooking::Schema::Result::Category;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

PiCooking::Schema::Result::Category

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

=head1 TABLE: C<Categories>

=cut

__PACKAGE__->table("Categories");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'text'
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "text", is_nullable => 0 },
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
  { "foreign.category_id" => "self.id" },
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
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:fO4zkiKUu4L0DwVwgvLw4g


__PACKAGE__->many_to_many("recipes", "recipes_categories", "recipe");

__PACKAGE__->meta->make_immutable;
1;
