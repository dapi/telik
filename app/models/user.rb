# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Основная модель пользователя
#
class User < ApplicationRecord
  strip_attributes
  authenticates_with_sorcery!

  has_many :accounts, class_name: 'UserAccount', dependent: :restrict_with_exception
  belongs_to :telegram_user

  has_many :memberships, dependent: :delete_all
  has_many :projects, through: :memberships

  after_create :create_accounts

  def to_s
    public_name
  end

  def self.authenticate(telegram_data)
    yield(
      User
        .create_with(telegram_data:)
        .find_or_create_by!(telegram_user_id: telegram_data.fetch('id')),
      nil)
  end

  def first_name
    telegram_data.fetch('first_name')
  end

  def public_name
    first_name || telegram_nick
  end

  def telegram_nick
    "@#{telegram_data.fetch('username')}"
  end

  private

  def create_accounts
    Currency.find_each do |currency|
      oa = OpenbillAccount.create! reference: self, currency:, category: OpenbillCategory.users
      accounts.create! openbill_account: oa, currency:
    end
  end
end
