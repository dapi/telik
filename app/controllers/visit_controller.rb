# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Учитывает визит пользователя. Это происходит по клику на виджете.
# Публичный контроллер.
#
class VisitController < ApplicationController
  COOKIE_KEY = :telik_visitor_id
  MAX_DATA_LENGTH = 256

  before_action :cookie_id

  def create
    redirect_to build_redirect_url, allow_other_host: true
    host_confirms unless project.host_confirmed?
  rescue ActiveRecord::RecordNotFound => e
    Rails.logger.error e
    Bugsnag.notify e do |b|
      b.severity = :warn
    end
    render :not_found
  end

  private

  def host_confirms
    host = Addressable::URI.parse(request.referer).host
    project.update host: host, host_confirmed_at: Time.zone.now if host.present?
  end

  def build_redirect_url
    ApplicationConfig.bot_url + '?start=' + create_visit.telegram_key
  end

  def create_visit
    Rails.logger.info("Location #{request.location}")
    visitor_session
      .visits
      .create!(
        referrer: request.referer,
        remote_ip: request.remote_ip,
        location: request.location.try(:data) || {},
        user_data: parse_data(:user),
        page_data: parse_data(:page),
        visit_data: parse_data(:visit)
      )
  end

  def visitor_session
    VisitorSession.create_or_find_by!(project:, cookie_id:)
  end

  def project
    Project.find_by!(key: params[:pk])
  end

  def cookie_id
    cookies.signed[COOKIE_KEY] ||= Nanoid.generate
  end

  def parse_data(key)
    return {} unless params[key].is_a? String
    return {} if params[key].length > MAX_DATA_LENGTH

    data = JSON.parse(params[key])
    data.is_a?(Hash) ? data : {}
  rescue JSON::ParserError => e
    Rails.logger.error e
    {}
  end
end
