set :rbenv_type, :user
set :rbenv_ruby, File.read('.ruby-version').strip
append :rbenv_map_bins, 'puma', 'pumactl'
