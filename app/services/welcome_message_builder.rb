# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Формирует приветственное сообщение
#
class WelcomeMessageBuilder < StringInterpolator
  DEFAULT_TEMPLATE = '%{project.username}: Привет, %{visitor.first_name}! Чем вам помочь?'

  def initialize(visit)
    @visit = visit || raise('bisit must be defined')
    @visitor = visit.visitor || raise('visit.visitor must be defined')
    @project = visit.project || raise('visit.project must be defined')
  end

  def build
    super(project.welcome_message.presence || DEFAULT_TEMPLATE)
  end
end
