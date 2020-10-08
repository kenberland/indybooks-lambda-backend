require 'lib/mock_dynamodb_offer_manager'
require 'lib/dynamodb_offer_manager'

require 'bundler'
Bundler.require

INDY_ENV = ENV['INDY_ENV']

offer_options = {
  region: ENV['AWS_REGION'],
  table_name: "indybooks_inventory_#{ENV['INDY_ENV']}"
}

if INDY_ENV == 'development'
  raise "Oh gosh I can't talk to the db" if ENV['AWS_ACCESS_KEY_ID'].nil? ||
                                            ENV['AWS_SECRET_ACCESS_KEY'].nil? ||
                                            ENV['AWS_ACCESS_KEY_ID'].empty? ||
                                            ENV['AWS_SECRET_ACCESS_KEY'].empty?
  offer_options[:endpoint] = 'http://localhost:8000'
end

store_options = offer_options.clone
store_options[:table_name] = "indybooks_stores_#{ENV['INDY_ENV']}"

if INDY_ENV == 'test'
  $offer_manager = MockDynamodbOfferManager.new(**offer_options)
  $store_manager = MockDynamodbManager.new(**store_options)
else
  $offer_manager = DynamodbOfferManager.new(**offer_options)
  $store_manager = DynamodbManager.new(**store_options)
end
