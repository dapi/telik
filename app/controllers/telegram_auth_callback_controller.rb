# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Контроллер аутентияикации участников проекта
# TODO: Переименовать в TelegramAuthCallback
#
class TelegramAuthCallbackController < ApplicationController
  def self.sign_params(data_params)
    data_check_string = data_params.sort.map { |k, v| [k, v].join('=') }.join("\n")
    secret_key = OpenSSL::Digest::SHA256.new(ApplicationConfig.bot_token).digest
    OpenSSL::HMAC.hexdigest('sha256', secret_key, data_check_string)
  end

  EXPIRED = 5

  before_action :authorize!

  def create
    login data_params

    url = if current_user.projects.many?
            projects_url
          elsif current_user.projects.one?
            project_url(current_user.projects.take)
          else
            root_url
          end

    redirect_back_or_to url, notice: t('flash.hi', username: current_user)
  end

  private

  def data_params
    @data_params ||= params
      .permit(:id, :first_name, :last_name, :username, :photo_url, :auth_date)
      .to_h
  end

  def authorize!
    return if signed? && fresh?

    raise HumanizedError, 'Unauthorized telegram callback'
  end

  def signed?
    self.class.sign_params(data_params) == params.fetch(:hash)
  end

  def fresh?
    Time.zone.at(params.fetch(:auth_date).to_i) >= EXPIRED.minutes.ago
  end
end
