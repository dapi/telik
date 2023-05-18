# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Базовый класс интерполяции строк
#
class StringInterpolator
  INTERPOLATION_PATTERN = /%\{(\w+)\.(\w+)\}/ # matches placeholders like "%{foo.upcase}"
  AVAILABLE_METHODS = %w[project_host project_username visitor_id visitor_name visitor_username visit_geo visit_host visitor_first_name].freeze
  CUSTOM_OBJECTS = %w[user_data page_data visit_data].freeze

  def build(template)
    template
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

  attr_reader :visitor, :visit, :project

  delegate :host, :username, to: :project, prefix: true
  delegate :id, :name, :username, :first_name, :last_name, to: :visitor, prefix: true
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
