# frozen_string_literal: true

require 'addressable/uri'

# Проект пользователя привязанный к сайту
#
class Project < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  has_many :memberships, dependent: :delete_all
  has_many :users, through: :memberships

  validates :url, presence: true, url: true, uniqueness: { scope: :owner_id }
  validates :host, presence: true

  validate :host do
    errors.add(:host) unless Addressable::URI.parse(url).host == host
  end

  before_create do
    self.key = Nanoid.generate
  end

  def host_confirmed?
    host_confirmed_at.present?
  end
end
