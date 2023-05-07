class Project < ApplicationRecord
  belongs_to :owner, class_name: User

  before_create do
    self.key = Nanoid.generate
  end
end
