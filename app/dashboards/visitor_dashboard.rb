# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'administrate/base_dashboard'

class VisitorDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    first_visits: Field::HasMany,
    last_visit_at: Field::DateTime,
    last_visits: Field::HasMany,
    operator_replied_at: Field::DateTime,
    project: Field::BelongsTo,
    telegram_cached_at: Field::DateTime,
    telegram_message_thread_id: Field::Number,
    telegram_user: Field::BelongsTo,
    topic_data: Field::String.with_options(searchable: false),
    user_data: Field::String.with_options(searchable: false),
    visitor_sessions: Field::HasMany,
    visits: Field::HasMany,
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
    first_visits
    last_visit_at
    last_visits
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    first_visits
    last_visit_at
    last_visits
    operator_replied_at
    project
    telegram_cached_at
    telegram_message_thread_id
    telegram_user
    topic_data
    user_data
    visitor_sessions
    visits
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    first_visits
    last_visit_at
    last_visits
    operator_replied_at
    project
    telegram_cached_at
    telegram_message_thread_id
    telegram_user
    topic_data
    user_data
    visitor_sessions
    visits
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

  # Overwrite this method to customize how visitors are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(visitor)
  #   "Visitor ##{visitor.id}"
  # end
end
