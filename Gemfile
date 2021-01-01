source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

gem 'dynamodb_geo'
gem 'json-schema'


group :test do
  gem 'rspec'
  gem 'rspec_junit_formatter'
  gem 'webmock'
end

group :test, :development do
  gem 'aws-sdk-dynamodb'
end

group :development do
  gem 'pry-byebug'
  gem 'sinatra'
  gem 'rake'
  #gem 'dynamodb_geo', git:'https://github.com/JA-Soonahn/dynamodb_geo'
  #gem 'dynamodb_geo'
end
