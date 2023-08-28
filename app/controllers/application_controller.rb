# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Базовый контроллер приложения
#
class ApplicationController < ActionController::Base
  private

  def not_authenticated
    flash.now[:alert] = 'Вы не авторизованы'
    render 'not_authenticated', layout: 'simple'
  end
end
