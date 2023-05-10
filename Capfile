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

require 'capistrano/rails/console'

# require 'capistrano/yarn'
require 'capistrano/rails/migrations'
require 'capistrano/dotenv/tasks'
require 'capistrano/dotenv'

require 'capistrano/systemd/multiservice'
install_plugin Capistrano::Systemd::MultiService.new_service('puma', service_type: 'user')
install_plugin Capistrano::Systemd::MultiService.new_service('sidekiq', service_type: 'user')

# require 'capistrano/datadog'
require 'capistrano/faster_assets'

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }

