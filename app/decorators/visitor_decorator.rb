# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Декоратор посетителя
#
class VisitorDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[telegram_username name created_at updated_at topic_subject visits user_data]
  end

  def self.attributes
    super + %i[telegram_user]
  end

  def topic_subject
    return '-' if object.topic_data.blank?

    h.link_to object.topic_data.fetch('name'), object.topic_url, target: '_blank', rel: 'noopener'
  end

  def name
    object.telegram_user.try(:name) || '-'
  end

  def telegram_user
    return '-' if object.telegram_user.nil?

    h.content_tag :pre do
      JSON.pretty_generate object.telegram_user.as_json
    end
  end

  def visits
    h.link_to object.visits_count, h.project_visits_path(project, q: { visitor_session_id_in: object.visitor_sessions.pluck(:id) })
  end

  def telegram_username
    return '-' if object.telegram_user.blank?

    if object.telegram_user.username.blank?
      object.telegram_user.name
    else
      h.link_to '@' + object.telegram_user.username.to_s, 'https://t.me/' + object.telegram_user.username.to_s, target: '_blank', rel: 'noopener'
    end
  end

  # Define presentation-specific methods here. Helpers are accessed through
  # `helpers` (aka `h`). You can override attributes, for example:
  #
  #   def created_at
  #     helpers.content_tag :span, class: 'time' do
  #       object.created_at.strftime("%a %m/%d/%y")
  #     end
  #   end
end
