class UserAccount < ApplicationRecord
  belongs_to :user
  belongs_to :openbill_account

  before_create do
    self.currency_code == openbill_account.currency_code
  end
end
