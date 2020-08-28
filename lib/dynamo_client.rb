INDY_ENV = ENV['INDY_ENV']

options = {
  region: ENV['AWS_REGION'],
  table_name: "indybooks_inventory_#{ENV['INDY_ENV']}"
}

if ENV['INDY_ENV'] == 'development'
  raise "Oh gosh I can't talk to the db" if ENV['AWS_ACCESS_KEY_ID'].nil? ||
                                            ENV['AWS_SECRET_ACCESS_KEY'].nil? ||
                                            ENV['AWS_ACCESS_KEY_ID'].empty? ||
                                            ENV['AWS_SECRET_ACCESS_KEY'].empty?
  options[:endpoint] = 'http://localhost:8000'
end

$offer_manager = DynamodbOfferManager.new(options)

#puts manager.table
#puts manager.query('9780520081987')
#binding.pry; 1

