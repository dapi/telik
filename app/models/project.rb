# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'addressable/uri'

# Проект пользователя привязанный к сайту
#
class Project < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  has_many :memberships, dependent: :delete_all
  has_many :users, through: :memberships

  has_many :visitors
  has_many :visits, through: :visitors

  validates :url, presence: true, url: true
  validates :host, presence: true

  validate :host do
    errors.add(:host) unless Addressable::URI.parse(url).host == host
  end

  before_create do
    self.key = Nanoid.generate
  end

  def last_visit
    return @last_visit if defined? @last_visit

    @last_visit = visits.order(:created_at).last
  end

  def host_confirmed?
    host_confirmed_at.present?
  end
end
