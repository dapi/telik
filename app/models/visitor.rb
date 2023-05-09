# frozen_string_literal: true

# Посетитель сайта нашего клиента
#
class Visitor < ApplicationRecord
  belongs_to :project
  has_many :visits, dependent: :delete_all

  has_one :last_visit, class_name: 'Visit', dependent: :nullify
  has_one :first_visit, class_name: 'Visit', dependent: :nullify

  validates :cookie_id, presence: true

  def topic_title
    remote_ip
  end
end
