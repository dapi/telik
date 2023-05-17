# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Формирует название топика для темы
#
class TopicTitleBuilder
  INTERPOLATION_PATTERN = /%\{(\w+)\.(\w+)\}/ # matches placeholders like "%{foo.upcase}"
  AVAILABLE_METHODS = %w[visitor_id visitor_name visitor_username visit_geo visit_host].freeze
  CUSTOM_OBJECTS = %w[user_data page_data visit_data].freeze

  DEFAULT_TOPIC_TITLE_TEMPLATE = '#%{visitor.id} %{visitor.name} %{visit.geo}'

  def build_topic(visitor, visit = nil)
    @visitor = visitor
    visit ||= visitor.last_visit
    @visit = visit

    (visitor.project.topic_title_template.presence || DEFAULT_TOPIC_TITLE_TEMPLATE)
      .gsub(INTERPOLATION_PATTERN) do |_match|
      _, object, field = *Regexp.last_match

      method = [object, field].join('_')

      if AVAILABLE_METHODS.include? method
        send(method).to_s
      elsif CUSTOM_OBJECTS.include?(object)
        send(object).fetch(field, '')
      else
        '%{' + object + '.' + field + '}'
      end
    end
  end

  private

  attr_reader :visitor, :visit

  delegate :id, :name, :username, to: :visitor, prefix: true
  delegate :geo, :referrer, :host, to: :visit, prefix: true, allow_nil: true

  def user_data
    @user_data ||= (visitor.user_data || {}).stringify_keys.freeze
  end

  def page_data
    @page_data ||= (visit.page_data || {}).stringify_keys.freeze
  end

  def visit_data
    @visit_data ||= (visit.visit_data || {}).stringify_keys.freeze
  end
end
