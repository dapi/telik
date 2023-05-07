class SessionsController < ApplicationController
  layout 'simple'

  def destroy
    logout
    redirect_to root_url, notice: t('flashes.logout')
  end
end
