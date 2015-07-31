web:        bundle exec thin start -p $PORT
search:     elasticsearch
memory:     redis-server
worker:     bundle exec sidekiq -C config/sidekiq-cron.yml
worker:     bundle exec sidekiq -C config/sidekiq-main.yml
