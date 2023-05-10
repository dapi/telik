set :dotenv_hook_commands, %w[rake rails ruby]

Capistrano::DSL.stages.each do |stage|
  after stage, 'dotenv:hook'
end

