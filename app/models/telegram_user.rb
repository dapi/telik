# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Пользователь телеграм
# id в таблице - id пользователя из телеги
#
class TelegramUser < ApplicationRecord
  self.primary_key = :id

  has_many :visitors, dependent: :nullify

  # chat =>
  # {"id"=>943084337, "first_name"=>"Danil", "last_name"=>"Pismenny", "username"=>"pismenny", "type"=>"private"}
  def update_from_chat!(chat)
    assign_attributes chat.slice(*%w[first_name last_name username])
    save! if changed?
  end

  def name
    [first_name, last_name].join(' ').presence || ('Incognito(' + id.to_s + ')')
  end
end
