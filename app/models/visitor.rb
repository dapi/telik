# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Посетитель сайта нашего клиента (так сказать в разрезе проекта)
#
class Visitor < ApplicationRecord
  belongs_to :project
  belongs_to :telegram_user

  has_many :visitor_sessions, dependent: :nullify
  has_many :visits, through: :visitor_sessions
  has_many :last_visits, through: :visitor_sessions
  has_many :first_visits, through: :visitor_sessions

  delegate :last_name, :first_name, :username, to: :telegram_user

  after_create do
    update_column :user_data, (user_data || {}).merge(last_visit.user_data) if last_visit.present?
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[
      created_at
      first_visit_id
      id
      last_visit_at
      last_visit_id
      project_id
      telegram_cached_at
      telegram_user_id
      telegram_message_thread_id
      topic_data
      updated_at
    ]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[first_visits last_visits project telegram_user visitor_sessions visits]
  end

  delegate :count, to: :visits, prefix: true

  def update_user_data!(user_data)
    update! user_data:
  end

  def to_s
    name
  end

  def user_data_object
    OpenStruct.new(user_data || {}).freeze
  end

  def first_visit
    @first_visit ||= first_visits.order(:created_at).first
  end

  # Имя используемое в чате в сообщениях "от"
  def last_visit
    @last_visit ||= last_visits.order(:created_at).last
  end

  # Имя используемое в чате в сообщениях "от"
  def name
    [first_name, last_name].join(' ').presence || ('Incognito(' + id.to_s + ')')
  end

  def topic_url
    raise "No telegram_message_thread_id for visitor ##{id}" if telegram_message_thread_id.nil?

    [project.telegram_group_prefix_url, telegram_message_thread_id].join('/')
  end
end
