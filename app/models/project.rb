class Project < ApplicationRecord
  belongs_to :owner, class_name: 'User'

  before_create do
    self.key = Nanoid.generate
  end

  def telegram_group_id
    -1001854699958
  end
end
