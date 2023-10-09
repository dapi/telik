# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'administrate/base_dashboard'

class TariffDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    archived_at: Field::DateTime,
    button_title: Field::String,
    custom_bot_allowed: Field::Boolean,
    details: Field::Text,
    is_default: Field::Boolean,
    marketing_mails_allowed: Field::Boolean,
    max_operators_count: Field::Number,
    max_visitors_count: Field::Number,
    position: Field::Number,
    price: Field::String.with_options(searchable: false),
    projects: Field::HasMany,
    title: Field::String,
    transaction_mails_allowed: Field::Boolean,
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
    archived_at
    button_title
    custom_bot_allowed
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    archived_at
    button_title
    custom_bot_allowed
    details
    is_default
    marketing_mails_allowed
    max_operators_count
    max_visitors_count
    position
    price
    projects
    title
    transaction_mails_allowed
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    archived_at
    button_title
    custom_bot_allowed
    details
    is_default
    marketing_mails_allowed
    max_operators_count
    max_visitors_count
    position
    price
    projects
    title
    transaction_mails_allowed
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

  # Overwrite this method to customize how tariffs are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(tariff)
  #   "Tariff ##{tariff.id}"
  # end
end
