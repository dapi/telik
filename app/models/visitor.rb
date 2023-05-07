class Visitor < ApplicationRecord
  has_many :visits
  validates :cookie_id, presence: true
end
