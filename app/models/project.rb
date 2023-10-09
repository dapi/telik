# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'addressable/uri'

# Проект пользователя привязанный к сайту
#
class Project < ApplicationRecord
  include ProjectBot
  include ProjectSetup

  BOT_STATUSES = %w[left administrator restricted member].freeze
  BOT_TOKEN_FORMAT = /\A[a-z0-9]+:[a-z0-9_-]+\z/i

  strip_attributes

  attr_accessor :just_created

  belongs_to :owner, class_name: 'User'
  belongs_to :tariff

  has_many :memberships, dependent: :delete_all
  has_many :users, through: :memberships

  has_many :visitor_sessions, dependent: :destroy
  has_many :visitors, dependent: :destroy
  has_many :visits, through: :visitor_sessions

  before_validation do
    self.url = 'http://' + url if url.present? && url.exclude?('://')
    self.name = Addressable::URI.parse(url).host if url.present? && name.blank?
  end

  validates :bot_token, presence: true, if: :bot_token_required?
  validates :bot_token,
            uniqueness: true,
            # uniqueness: { message: -> (project, validation) { 'aaa' } },
            format: { with: BOT_TOKEN_FORMAT, message: 'имеет не верный формат' },
            if: :bot_token?
  validate :validate_bot_token
  validates :name, presence: true
  validates :url, url: true, if: :url?
  validates :skip_threads_ids, type: Array
  validates :bot_username,
            presence: true,
            uniqueness: { message: 'Уже заведен проект с таким токеном' },
            if: :bot_token?

  # Есть два способа создания проекта.
  # Вариант 1. Сначала создается группа, к группе добавляется бот и тогда бот создает проект
  # привязывается проект.
  #
  # Вариант 2. Сначала создается проект с ботом, затем к непу прикручивается группа.
  validates :telegram_group_id, presence: true, unless: :bot_token_required?

  before_create do
    self.key = Nanoid.generate
  end

  before_save do
    self.host = url.present? ? Addressable::URI.parse(url).host : nil
  end

  after_create :add_owner_as_member

  after_create do
    self.just_created = true
  end

  after_commit do
    ProjectRelayJob.perform_later self
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[bot_can_manage_topics bot_status chat_member chat_member_updated_at created_at custom_username host host_confirmed_at id key last_error last_error_at name owner_id telegram_chat telegram_group_id telegram_group_is_forum telegram_group_type updated_at url]
  end

  def title
    name.presence || telegram_group_name
  end

  def add_owner_as_member
    memberships.create_or_find_by! user: owner
  end

  def add_skipped_topic!(thread_id)
    Rails.logger.info "Add skipped topic #{thread_id} to project #{id}"
    with_lock do
      update! skip_threads_ids: skip_threads_ids + [thread_id]
    end
  end

  def member?(user)
    owner_id == user.id || users.include?(user)
  end

  def username
    host || name || custom_username
  end

  def notify_telegram_user_ids
    memberships.joins(:user, :project).pluck(:telegram_user_id).uniq
  end

  def telegram_group_prefix_url
    ['https://t.me/c', telegram_group_id.to_s.sub('-100', '')].join('/')
  end

  def telegram_group_url
    telegram_group_prefix_url + '/1'
  end

  def last_visit
    return @last_visit if defined? @last_visit

    @last_visit = visits.order(:created_at).last
  end

  def host_confirmed?
    host_confirmed_at.present?
  end
end
