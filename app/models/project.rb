class Project < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  has_many :memberships
  has_many :users, through: :memberships

  before_create do
    self.key = Nanoid.generate
  end
end
