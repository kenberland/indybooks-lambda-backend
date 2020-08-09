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
require 'pry'

raise "Oh gosh I can't talk to the db" if ENV['AWS_ACCESS_KEY_ID'].nil? ||
                                          ENV['AWS_SECRET_ACCESS_KEY'].nil? ||
                                          ENV['AWS_ACCESS_KEY_ID'].empty? ||
                                          ENV['AWS_SECRET_ACCESS_KEY'].empty?

my_options = {
  endpoint: 'http://localhost:8000',
  region: ENV['AWS_REGION'],
  table_name: "indybooks_production"
}

foo = DynamodbGeo.new(my_options)
my_store_hash = {
  latitude: 37.8651098,
  longitude: -122.2573473,
  address: '2509 Telegraph Ave',
  city: 'Berkeley',
  state: 'CA',
  zip: 94704,
  area_code: 925,
  phone: 2589076,
  name: 'Sleepy Cat Books'
}


my_store = Store.new(my_store_hash)
foo.put_store(my_store)
binding.pry;1

