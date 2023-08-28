# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Декоратор посещения
class VisitDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[created_at visitor geo remote_ip referrer page_data visit_data user_data]
  end

  def self.attributes
    table_columns + %i[location registered_at]
  end

  def created_at
    h.link_to super, h.project_visit_path(object.project.id, object)
  end

  def user_data
    h.content_tag :pre, object.user_data
  end

  def visit_data
    h.content_tag :pre, object.visit_data
  end

  def page_data
    h.content_tag :pre, object.page_data
  end

  def location
    h.content_tag :pre do
      JSON.pretty_generate object.location
    end
  end

  def visitor
    return '-' if object.visitor.nil?
    VisitorDecorator.decorate(object.visitor).telegram_user
  end

  def geo
    h.content_tag :span, object.geo, title: object.location
  end
end
