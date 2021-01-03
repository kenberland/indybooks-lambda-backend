require 'lib/mock_dynamodb_offer_manager'
require 'lib/mock_dynamodb_pile_manager'
require 'lib/mock_dynamodb_user_pile_manager'
require 'lib/mock_dynamodb_purchase_manager'
require 'lib/mock_dynamodb_helpers'
require 'lib/dynamodb_offer_manager'
require 'lib/dynamodb_purchase_manager'
require 'lib/dynamodb_pile_manager'
require 'lib/dynamodb_user_pile_manager'
require 'lib/helpers'

require 'bundler'

Bundler.require

offer_options = {
  region: ENV['AWS_REGION'],
  table_name: "indybooks_inventory_#{ENV['INDY_ENV']}"
}

if INDY_ENV == 'development'
  raise "Oh gosh I can't talk to the db because" +
          "AWS_ACCESS_KEY_ID = #{ENV['AWS_ACCESS_KEY_ID']}, " +
          "AWS_SECRET_ACCESS_KEY = #{ENV['AWS_SECRET_ACCESS_KEY']}, " +
          "AWS_ACCESS_KEY_ID = #{ENV['AWS_ACCESS_KEY_ID']}, " +
          "AWS_SECRET_ACCESS_KEY = #{ENV['AWS_SECRET_ACCESS_KEY']}" if ENV['AWS_ACCESS_KEY_ID'].nil? ||
                                                                       ENV['AWS_SECRET_ACCESS_KEY'].nil? ||
                                                                       ENV['AWS_ACCESS_KEY_ID'].empty? ||
                                                                       ENV['AWS_SECRET_ACCESS_KEY'].empty?
  offer_options[:endpoint] = 'http://localhost:8000'
end

store_options = offer_options.clone
store_options[:table_name] = "indybooks_stores_#{ENV['INDY_ENV']}"

pile_options = offer_options.clone
pile_options[:table_name] = "indybooks_piles_#{ENV['INDY_ENV']}"

user_pile_options = offer_options.clone
user_pile_options[:table_name] = "indybooks_user_piles_#{ENV['INDY_ENV']}"

purchase_options = offer_options.clone
purchase_options[:table_name] = "indybooks_purchases_#{ENV['INDY_ENV']}"


if INDY_ENV == 'test'
  $pile_manager    =  MockDynamodbPileManager.new(**pile_options)
  $user_pile_manager    =  MockDynamodbUserPileManager.new(**pile_options)
  $offer_manager    = MockDynamodbOfferManager.new(**offer_options)
  $purchase_manager = MockDynamodbPurchaseManager.new(**purchase_options)
  $store_manager    = MockDynamodbManager.new(**store_options)
else
  $pile_manager     = DynamodbPileManager.new(**pile_options)
  $user_pile_manager     = DynamodbUserPileManager.new(**user_pile_options)
  $offer_manager    = DynamodbOfferManager.new(**offer_options)
  $purchase_manager = DynamodbPurchaseManager.new(**purchase_options)
  $store_manager    = DynamodbManager.new(**store_options)
end
