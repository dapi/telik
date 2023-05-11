client_bot:  bundle exec rake telegram:bot:poller BOT=client
operator_bot:  bundle exec rake telegram:bot:poller BOT=operator
web: rails s -p $PORT
# https: ng serve --ssl --host $RAILS_DEVELOPMENT_HOST --port 443
dependents: docker-compose up
