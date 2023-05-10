# Copyright © 2023 Danil Pismenny <danil@brandymint.ru>

# frozen_string_literal: true

set :dotenv_hook_commands, %w[rake rails ruby]

Capistrano::DSL.stages.each do |stage|
  after stage, 'dotenv:hook'
end
