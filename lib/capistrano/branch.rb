set :repo_url, ENV.fetch('DEPLOY_REPO_URL', `git remote -v | grep origin | head -1 | awk '{ print $2 }'`.chomp) if ENV['USE_LOCAL_REPO'].nil?

default_branch = 'master'
current_branch = `git rev-parse --abbrev-ref HEAD`.chomp

if ENV.key? 'BRANCH'
  set :branch, ENV.fetch('BRANCH')
elsif default_branch == current_branch
  set :branch, default_branch
else
  ask(:branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp })
end

set :current_version, `git rev-parse HEAD`.strip
