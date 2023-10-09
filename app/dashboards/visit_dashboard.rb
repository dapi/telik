# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'administrate/base_dashboard'

class VisitDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    chat: Field::String.with_options(searchable: false),
    key: Field::String,
    location: Field::String.with_options(searchable: false),
    page_data: Field::String.with_options(searchable: false),
    project: Field::HasOne,
    referrer: Field::String,
    registered_at: Field::DateTime,
    remote_ip: Field::String.with_options(searchable: false),
    user_data: Field::String.with_options(searchable: false),
    visit_data: Field::String.with_options(searchable: false),
    visitor: Field::HasOne,
    visitor_session: Field::BelongsTo,
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
    chat
    key
    location
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    chat
    key
    location
    page_data
    project
    referrer
    registered_at
    remote_ip
    user_data
    visit_data
    visitor
    visitor_session
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    chat
    key
    location
    page_data
    project
    referrer
    registered_at
    remote_ip
    user_data
    visit_data
    visitor
    visitor_session
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

  # Overwrite this method to customize how visits are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(visit)
  #   "Visit ##{visit.id}"
  # end
end
