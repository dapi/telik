# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Посетитель сайта нашего клиента
#
class Visitor < ApplicationRecord
  belongs_to :project
  has_many :visits, dependent: :delete_all

  has_one :last_visit, class_name: 'Visit', dependent: :nullify
  has_one :first_visit, class_name: 'Visit', dependent: :nullify

  validates :cookie_id, presence: true

  # chat =>
  # {"id"=>943084337, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "type"=>"private"}
  def update_user_from_chat!(chat)
    assign_attributes chat.slice(*%w[first_name last_name username]).merge(telegram_id: chat.fetch('id'))
    save! if changed?
  end

  def topic_title
    # TODO: Добавлять опционально @#{username}
    "##{id} #{name} из #{last_visit.city} (#{last_visit.region}/#{last_visit.country})"
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
