require 'bundler'
Bundler.require
libpath = File.join(File.expand_path(File.dirname(__FILE__)), 'lib')
$LOAD_PATH.unshift(libpath) unless $LOAD_PATH.include?(libpath)

require 'dynamodb_purchase_manager'

task default: %w[create_purchases_table]

task :create_purchases_table do
  options = {
    region: ENV['AWS_REGION'],
    table_name: "indybooks_purchases_#{ENV['INDY_ENV']}"
  }

  if ENV['INDY_ENV'] != 'production'
    options[:endpoint] = 'http://localhost:8000'
  end

  manager = DynamodbPurchaseManager.new(**options)
  puts manager.create_table

  MY_JSON = File.read('purchases/purchase.json')
  payload = JSON.parse(MY_JSON, object_class: OpenStruct)
  puts payload.purchase.inspect
  manager.put(payload.purchase)
  puts manager.get('d487f93c-4617-11eb-b378-0242ac130002')
end
