# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

require 'rubygems'
require 'bundler'
Bundler.setup(:deploy)

# Load DSL and Setup Up Stages
require 'capistrano/setup'

# Includes default deployment tasks
require 'capistrano/deploy'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

require 'capistrano/rbenv'
# require 'capistrano/nvm'
require 'capistrano/bundler'
require 'capistrano/rails/assets'
require 'capistrano-db-tasks'
require 'capistrano/shell'
require 'capistrano/master_key'

require 'capistrano/rails/console'

# require 'capistrano/yarn'
require 'capistrano/rails/migrations'
require 'capistrano/dotenv/tasks'
require 'capistrano/dotenv'

require 'capistrano/puma'
install_plugin Capistrano::Puma
install_plugin Capistrano::Puma::Systemd

require 'capistrano/systemd/multiservice'
install_plugin Capistrano::Systemd::MultiService.new_service('sidekiq', service_type: 'user')

require 'capistrano/faster_assets' unless ENV['FORCE_ASSETS']

Dir.glob('lib/capistrano/*.rb').each { |r| import r }
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
