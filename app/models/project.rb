# frozen_string_literal: true

# Проект пользователя привязанный к сайту
#
class Project < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  has_many :memberships, dependent: :delete_all
  has_many :users, through: :memberships

  before_create do
    self.key = Nanoid.generate
  end
end
