class Visit < ApplicationRecord
  TELEGRAM_KEY_PREFIX = 'v_'
  belongs_to :visitor

  before_create do
    self.key = Nanoid.generate
  end

  def telegram_key
    TELEGRAM_KEY_PREFIX + key
  end
end
