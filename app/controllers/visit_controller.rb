# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Учитывает визит пользователя. Это происходит по клику на виджете.
# Публичный контроллер.
#
class VisitController < ApplicationController
  COOKIE_KEY = :telik_visitor_id
  before_action :cookie_id

  def create
    redirect_to build_redirect_url, allow_other_host: true
  end

  private

  def build_redirect_url
    ApplicationConfig.bot_url + '?start=' + create_visit.telegram_key
  end

  def create_visit
    find_or_create_visitor
      .visits
      .create!(
        referrer: request.referer,
        remote_ip: request.remote_ip,
        location: request.location.try(:data) || {},
        data:
      )
  end

  def find_or_create_visitor
    Visitor.create_or_find_by!(project:, cookie_id:)
  end

  def project
    Project.find_by!(key: params[:pk])
  end

  def cookie_id
    cookies.signed[COOKIE_KEY] ||= Nanoid.generate
  end

  def data
    return {} unless params[:data].is_a? Hash
    return {} if params[:data].to_s.length > MAX_DATA_LENGTH

    params[:data]
  end
end
