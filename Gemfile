# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

group :test do
  gem 'rspec'
  gem 'rspec_junit_formatter'
end

group :test, :development do
  gem 'aws-sdk-dynamodb'
end

group :development do
  gem 'pry'
  gem 'sinatra'
  #gem 'dynamodb_geo', git:'https://github.com/JA-Soonahn/dynamodb_geo'
  #gem 'dynamodb_geo'
end
