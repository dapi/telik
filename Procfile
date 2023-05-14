bot: bundle exec rake telegram:bot:poller
web: rails s -p $PORT
# https://levelup.gitconnected.com/how-to-proxy-https-traffic-to-your-development-server-63c9980d5899
https: sudo ssl-proxy-darwin-amd64 -from 0.0.0.0:443 -to 127.0.0.1:3000
dependents: docker-compose up
