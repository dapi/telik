# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'administrate/base_dashboard'

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    crypted_password: Field::String,
    email: Field::String,
    last_activity_at: Field::DateTime,
    last_login_at: Field::DateTime,
    last_login_from_ip_address: Field::String,
    last_logout_at: Field::DateTime,
    memberships: Field::HasMany,
    projects: Field::HasMany,
    remember_me_token: Field::String,
    remember_me_token_expires_at: Field::DateTime,
    salt: Field::String,
    super_admin: Field::Boolean,
    telegram_user: Field::BelongsTo,
    created_at: Field::DateTime,
    updated_at: Field::DateTime
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    crypted_password
    email
    last_activity_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    crypted_password
    email
    last_activity_at
    last_login_at
    last_login_from_ip_address
    last_logout_at
    memberships
    projects
    remember_me_token
    remember_me_token_expires_at
    salt
    super_admin
    telegram_user
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    crypted_password
    email
    last_activity_at
    last_login_at
    last_login_from_ip_address
    last_logout_at
    memberships
    projects
    remember_me_token
    remember_me_token_expires_at
    salt
    super_admin
    telegram_user
  ].freeze

  # COLLECTION_FILTERS
  # a hash that defines filters that can be used while searching via the search
  # field of the dashboard.
  #
  # For example to add an option to search for open resources by typing "open:"
  # in the search field:
  #
  #   COLLECTION_FILTERS = {
  #     open: ->(resources) { resources.where(open: true) }
  #   }.freeze
  COLLECTION_FILTERS = {}.freeze

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(user)
  #   "User ##{user.id}"
  # end
end
