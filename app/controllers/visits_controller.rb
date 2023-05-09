class VisitsController < ApplicationController
  before_action :cookie_id

  def create
    data = params[:data] || {}
    project = Project.find_by_key!(params[:pk])
    visit =
      Visitor
      .create_or_find_by!(project_id: project.id, cookie_id: cookie_id)
      .visits
      .create!(
        url: request.referrer.to_s,
        remote_ip: request.remote_ip,
        data: data
      )

    redirect_to(
      "https://t.me/#{Rails.application.credentials.telegram.bots.support.username}?start=" + visit.telegram_key,
      allow_other_host: true
    )
  end

  private

  def cookie_id
    cookies[:telik_visitor_id] ||= Nanoid.generate
  end
end
