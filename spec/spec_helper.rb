ENV['INDY_ENV'] = 'test'

Bundler.require(:default, 'test')

root = File.expand_path("..", File.dirname(__FILE__))
$LOAD_PATH.unshift(root) unless $LOAD_PATH.include?(root)

Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

require 'webmock/rspec'
require 'pry'
