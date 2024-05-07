# frozen_string_literal: true

source 'https://rubygems.org'

ruby '3.3.1'

gem 'bcrypt', '~> 3.1'
gem 'google-apis-gmail_v1', '~> 0.39.0', require: 'google/apis/gmail_v1'
gem 'googleauth', '~> 1.11', require: ['googleauth',
                                       'googleauth/web_user_authorizer',
                                       'googleauth/stores/redis_token_store']
gem 'puma', '~> 6.4'
gem 'rackup', '~> 2.1'
gem 'redis', '~> 5.2'
gem 'sendgrid-ruby', '~> 6.7'
gem 'sidekiq', '~> 7.2'
gem 'sinatra', '~> 4.0', require: 'sinatra/base'

group :development do
  gem 'rubocop', '~> 1.63', require: false
  gem 'ruby-lsp', '~> 0.16.6', require: false
end
