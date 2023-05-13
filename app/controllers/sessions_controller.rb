# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

# Собственно пользовательская сессия
#
class SessionsController < ApplicationController
  layout 'simple'

  def destroy
    logout
    redirect_to root_url(format: :html), status: :see_other, notice: t('flash.buy')
  end
end
