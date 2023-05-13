# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'addressable/uri'

# Проект пользователя привязанный к сайту
#
class Project < ApplicationRecord
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
    self.host = Addressable::URI.parse(url).host
  end

  after_create do
    self.just_created = true
  end

  def username
    host || name || custom_username
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
