# frozen_string_literal: true

# Основная модель пользователя
#
class User < ApplicationRecord
  strip_attributes
  authenticates_with_sorcery!
  def to_s
    public_name
  end

  def public_name
    email || telegram_nick
  end

  def telegram_nick
    "@#{telegram_data.fetch('username')}"
  end
end