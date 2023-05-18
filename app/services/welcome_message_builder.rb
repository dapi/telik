# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Формирует приветственное сообщение
#
class WelcomeMessageBuilder < StringInterpolator
  DEFAULT_TEMPLATE = '%{project.username}: Привет, %{visitor.first_name}! Чем вам помочь?'

  def initialize(visit)
    @visit = visit
    @visitor = visit.visitor
    @project = visit.project
  end

  def build
    super(project.welcome_message.presence || DEFAULT_TEMPLATE)
  end
end
