source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'dynamodb_geo'
gem 'json-schema'


group :test do
  gem 'aws-sdk-dynamodb'
  gem 'rspec'
  gem 'rspec_junit_formatter'
  gem 'webmock'
end

group :development do
  gem 'aws-sdk-dynamodb'
  gem 'pry-byebug'
  gem 'sinatra'
  gem 'rake'
end
