# Description: Creates a new DynamodbManager object.  Inputs are variables to your AWS account.
#             If access_key_id and secret_access_key are provided they are used.
#             If not provided, it falls back to ENV variables, then secret credential storage (profile name).
#             All arguments are keyword arguments
# Input:  region            => String
#         table_name        => String
#         access_key_id     => String
#         secret_access_key => String
#         profile_name      => 'default'
# Output: Aws::DynamoDB::Client
require 'dynamodb_geo'
require 'dynamodb_offer_manager'
#require 'pry'

options = {
  region: ENV['AWS_REGION'],
  table_name: 'indybooks_inventory_production'
}

if ENV['INDY_ENV'] == 'development'
  raise "Oh gosh I can't talk to the db" if ENV['AWS_ACCESS_KEY_ID'].nil? ||
                                            ENV['AWS_SECRET_ACCESS_KEY'].nil? ||
                                            ENV['AWS_ACCESS_KEY_ID'].empty? ||
                                            ENV['AWS_SECRET_ACCESS_KEY'].empty?
  options[:endpoint] = 'http://localhost:8000'
end

$offer_manager = DynamodbOfferManager.new(options) unless
  ENV['INDY_ENV'] == 'test'

#puts manager.table
#puts manager.query('9780520081987')
#binding.pry; 1

