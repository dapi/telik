# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

require 'administrate/base_dashboard'

# Основной дашборд в админке
#
class ProjectDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    bot_can_manage_topics: Field::Boolean,
    bot_id: Field::String,
    bot_status: Field::String,
    bot_token: Field::String,
    bot_username: Field::String,
    chat_member: Field::JSONB,
    chat_member_updated_at: Field::DateTime,
    custom_username: Field::String,
    host: Field::String,
    host_confirmed_at: Field::DateTime,
    key: Field::String,
    last_error: Field::String,
    last_error_at: Field::DateTime,
    memberships: Field::HasMany,
    name: Field::String,
    owner: Field::BelongsTo,
    skip_threads_ids: Field::String.with_options(searchable: false),
    tariff: Field::BelongsTo,
    telegram_chat: Field::JSONB,
    telegram_group_id: Field::Number,
    telegram_group_is_forum: Field::Boolean,
    telegram_group_name: Field::String,
    telegram_group_type: Field::String,
    thread_on_start: Field::Boolean,
    topic_title_template: Field::String,
    url: Field::String,
    users: Field::HasMany,
    visitor_sessions: Field::HasMany,
    visitors: Field::HasMany,
    visits: Field::HasMany,
    welcome_message: Field::String,
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
    bot_can_manage_topics
    bot_id
    bot_status
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    bot_can_manage_topics
    bot_id
    bot_status
    bot_token
    bot_username
    chat_member
    chat_member_updated_at
    custom_username
    host
    host_confirmed_at
    key
    last_error
    last_error_at
    memberships
    name
    owner
    skip_threads_ids
    tariff
    telegram_chat
    telegram_group_id
    telegram_group_is_forum
    telegram_group_name
    telegram_group_type
    thread_on_start
    topic_title_template
    url
    users
    visitor_sessions
    visitors
    visits
    welcome_message
    created_at
    updated_at
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    bot_can_manage_topics
    bot_id
    bot_status
    bot_token
    bot_username
    chat_member
    chat_member_updated_at
    custom_username
    host
    host_confirmed_at
    key
    last_error
    last_error_at
    memberships
    name
    owner
    skip_threads_ids
    tariff
    telegram_chat
    telegram_group_id
    telegram_group_is_forum
    telegram_group_name
    telegram_group_type
    thread_on_start
    topic_title_template
    url
    users
    visitor_sessions
    visitors
    visits
    welcome_message
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

  # Overwrite this method to customize how projects are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(project)
  #   "Project ##{project.id}"
  # end
end
