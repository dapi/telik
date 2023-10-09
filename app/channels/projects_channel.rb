# frozen_string_literal: true

# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# Канал обновлений проекта, используется при установке/настройке проекта
#
class ProjectsChannel < ApplicationCable::Channel
  def subscribed
    project = current_user.projects.find params[:id]
    stream_from 'projects:' + project.to_param
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
