# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "welcome#index"
  telegram_webhook Telegram::SupportBot::WebhookController, :support
  telegram_webhook Telegram::OperatorBot::WebhookController, :operator

  get 'telegram/auth_callback'

  get 'v', to: 'visits#create'

  resources :sessions, only: %i[new create] do
    collection do
      delete :destroy
    end
  end
end
