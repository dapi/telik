# frozen_string_literal: true

# Учитывает визит пользователя. Это происходит по клику на виджете
#
class VisitsController < ApplicationController
  before_action :cookie_id

  def create
    visit =
      Visitor
      .create_or_find_by!(project:, cookie_id:)
      .visits
      .create!(
        referrer: request.referer,
        remote_ip: request.remote_ip,
        location: request.location,
        data:
      )

    redirect_to(
      url_from("https://t.me/#{Rails.application.credentials.telegram.bots.support.username}?start=" + visit.telegram_key),
      allow_other_host: true
    )
  end

  private

  def project
    Project.find_by!(key: params[:pk])
  end

  def cookie_id
    cookies[:telik_visitor_id] ||= Nanoid.generate
  end

  def data
    return {} unless params[:data].is_a? Hash
    return {} if params[:data].to_s.length > MAX_DATA_LENGTH

    params[:data]
  end
end
