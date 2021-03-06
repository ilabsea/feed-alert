source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
# Use mysql as the database for Active Record
gem 'mysql2'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
gem 'active_model_serializers'
gem 'unicorn'

gem 'bootstrap-sass', '~> 3.3.3'

gem 'email_validator'
gem "validate_url"

gem 'kaminari'
gem 'bootstrap-kaminari-views'
gem 'simple_form'
gem 'twitter-typeahead-rails'
gem 'rails4-autocomplete', '~> 1.1.1'
gem 'feedjira'
gem 'sinatra', :require => nil

gem 'sidekiq', '~> 3.5.4'
gem "sidekiq-cron", "~> 0.3.0"

gem 'roadie-rails', '~> 1.1.0'
gem 'nuntium_api', github: 'channainfo/nuntium-api-ruby', branch: 'encode_uri'

gem 'whenever', :require => false

gem 'elasticsearch-persistence', '~> 0.1.9', require: 'elasticsearch/persistence/model'
gem 'elasticsearch-model', '~> 0.1.9'
gem 'elasticsearch-rails', '~> 0.1.9'
gem 'elasticsearch', '~> 1.1.3'

gem 'annotate', '~> 2.7.0'
gem 'foreman'
gem 'newrelic_rpm'

gem 'open_uri_redirections'
gem "ruby-readability", :require => 'readability'

gem "strip_attributes"

gem 'haml-rails', '~> 1.0'

group :development do
  gem 'capistrano', '3.4.0'
  gem 'capistrano-rails'
  gem 'capistrano-rbenv'
  gem 'capistrano-bundler'
  gem 'capistrano-passenger' #using gem passenger 4.0.58
  gem 'thin'
  # gem 'ruby-prof'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 10.0.2'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # gem 'dotenv-rails'
  gem 'factory_girl_rails'
  gem 'pry-rails', '~> 0.3.9'
  gem 'faker'
  gem 'ffaker'
  gem 'rspec-rails', '~> 3.9.0'
  gem 'spring-commands-rspec'
  gem 'guard-rspec', require: false
end

group :production do
  gem 'rails_12factor'
end

group :test do
  gem 'rake'
  gem "codeclimate-test-reporter", require: nil

  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'simplecov', require: false
  gem 'timecop'
  gem 'vcr', '~> 5.1.0'
  gem 'webmock'
end
