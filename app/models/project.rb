# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'addressable/uri'

# Проект пользователя привязанный к сайту
#
class Project < ApplicationRecord
  BOT_STATUSES = %w[left administrator restricted member].freeze

  strip_attributes

  attr_accessor :just_created

  belongs_to :owner, class_name: 'User'

  has_many :memberships, dependent: :delete_all
  has_many :users, through: :memberships

  has_many :visitors, dependent: :destroy
  has_many :visits, through: :visitors

  validates :name, presence: true
  validates :url, url: true, if: :url?
  validates :telegram_group_id, presence: true

  before_create do
    self.key = Nanoid.generate
  end

  before_update do
    self.host = url.present? ? Addressable::URI.parse(url).host : nil
  end

  after_create :add_owner_as_member

  after_create do
    self.just_created = true
  end

  def add_owner_as_member
    memberships.create_or_find_by! user: owner
  end

  def member?(user)
    owner_id == user.id || users.include?(user)
  end

  def username
    host || name || custom_username
  end

  # Бот подключен в группу?
  def bot_connected?
    bot_status.present?
    # bot_status == 'administrator'
  end

  def notify_telegram_ids
    memberships.joins(:user, :project).pluck(:telegram_id).uniq
  end

  def update_bot_member!(chat_member:, chat:)
    raise 'Project must be not changed' if changed?

    assign_attributes(
      telegram_chat: chat,
      telegram_group_is_forum: chat['is_forum'],
      telegram_group_type: chat.fetch('type'),
      bot_status: chat_member.fetch('status'),
      bot_can_manage_topics: chat_member['can_manage_topics'],
      chat_member:
    )
    return unless changed?

    self.chat_member_updated_at = Time.zone.now
    save!
  end

  def telegram_group_url
    ['https://t.me/c', telegram_group_id.to_s.sub('-100', '')].join('/')
  end

  def last_visit
    return @last_visit if defined? @last_visit

    @last_visit = visits.order(:created_at).last
  end

  def host_confirmed?
    host_confirmed_at.present?
  end
end
