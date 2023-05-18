# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Формирует название топика для темы
#
class TopicTitleBuilder < StringInterpolator
  DEFAULT_TEMPLATE = '#%{visitor.id} %{visitor.name} %{visit.geo}'

  def initialize(visitor, visit = nil)
    @visitor = visitor
    @visit = visit || visitor.last_visit
    @project = visitor.project
  end

  def build
    super(project.topic_title_template.presence || DEFAULT_TEMPLATE)
  end
end
