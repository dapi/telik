if defined? Capistrano::Nvm
  set :nvm_type, :user # or :system, depends on your nvm setup
  set :nvm_node, File.read('.nvmrc').strip
  set :nvm_map_bins, %w[node yarn]
end
