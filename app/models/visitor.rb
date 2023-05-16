# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Посетитель сайта нашего клиента (так сказать в разрезе проекта)
#
class Visitor < ApplicationRecord
  belongs_to :project
  belongs_to :telegram_user, optional: true

  has_many :visitor_sessions, dependent: :nullify

  delegate :last_name, :first_name, :username, to: :telegram_user

  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at first_name first_visit_id id last_name last_visit_at last_visit_id project_id telegram_cached_at telegram_user_id telegram_message_thread_id topic_data updated_at username]
  end

  def topic_title
    # TODO: Добавлять опционально @#{username}
    # "##{id} #{name} из #{last_visit.city} (#{last_visit.region}/#{last_visit.country})"
    "##{id} #{name}"
  end

  # Имя используемое в чате в сообщениях "от"
  def name
    [first_name, last_name].join(' ').presence || ('Incognito(' + id.to_s + ')')
  end

  def topic_url
    raise "No telegram_message_thread_id for visitor ##{id}" if telegram_message_thread_id.nil?

    [project.telegram_group_url, telegram_message_thread_id].join('/')
  end
end
