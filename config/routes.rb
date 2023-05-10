# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root 'welcome#index'
  telegram_webhook Telegram::SupportBot::WebhookController, :support
  telegram_webhook Telegram::OperatorBot::WebhookController, :operator

  get 'telegram/auth_callback'

  get 'v', to: 'visits#create'

  resources :sessions, only: %i[new create] do
    collection do
      delete :destroy
    end
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
