# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Декоратор посещения
class VisitDecorator < ApplicationDecorator
  delegate_all

  def self.table_columns
    %i[created_at visitor geo remote_ip referrer page_data visit_data user_data]
  end

  def visitor
    VisitorDecorator.decorate(object.visitor).topic_subject
  end

  def geo
    h.content_tag :span, object.geo, title: object.location
  end
end
