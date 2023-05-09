class Visitor < ApplicationRecord
  has_many :visits
  has_one :last_visit, class_name: 'Visit'
  has_one :first_visit, class_name: 'Visit'

  validates :cookie_id, presence: true
end
