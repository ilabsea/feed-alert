web:        bundle exec thin start -p $PORT
worker:     bundle exec sidekiq -q default -q mailers
search:     elasticsearch
memory:     redis-server