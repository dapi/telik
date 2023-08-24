# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'welcome#index'

  telegram_webhook Telegram::WebhookController unless Rails.env.test?

  get 'telegram/auth_callback', to: 'telegram_auth_callback#create'
  get 'v', to: 'visit#create'

  resources :sessions, only: %i[new create] do
    collection do
      delete :destroy
    end
  end

  resources :projects do
    resource :widget, only: %i[show create], controller: 'project/widget'
    resource :bot, only: %i[show create], controller: 'project/bot'
    resources :visits, only: %i[index show], controller: 'project/visits'
    resources :visitors, only: %i[index show], controller: 'project/visitors'
  end

  require 'sidekiq/web'

  if Rails.env.production?
    Sidekiq::Web.use Rack::Auth::Basic do |username, password|
      # Protect against timing attacks:
      # - See https://codahale.com/a-lesson-in-timing-attacks/
      # - See https://thisdata.com/blog/timing-attacks-against-string-comparison/
      # - Use & (do not use &&) so that it doesn't short circuit.
      # - Use digests to stop length information leaking
      #   (see also ActiveSupport::SecurityUtils.variable_size_secure_compare)
      ActiveSupport::SecurityUtils.secure_compare(Digest::SHA256.hexdigest(username),
                                                  Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_USERNAME', nil))) &
        ActiveSupport::SecurityUtils.secure_compare(Digest::SHA256.hexdigest(password),
                                                    Digest::SHA256.hexdigest(ENV.fetch('SIDEKIQ_PASSWORD', nil)))
    end
  end

  get '/sidekiq-stats' => proc {
                            [200, { 'Content-Type' => 'application/json' },
                             [{ stats: Sidekiq::Stats.new, queues: Sidekiq::Stats.new.queues }.to_json]]
                          }

  mount Sidekiq::Web => '/sidekiq'
end
