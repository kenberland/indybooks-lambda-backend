class MockDynamoResults
  attr_accessor :items
  def initialize(items)
    @items = items
  end
end

class MockDynamodbOfferManager
  attr_accessor :client, :table_name
  def initialize(region:, table_name:, access_key_id: nil,
                 secret_access_key: nil,
                 session_token: nil,
                 profile_name: 'default', endpoint: nil)

    @table_name      = table_name

    @client = {
      region:      region,
      endpoint:    endpoint
    }
  end

  def query(isbn)
    MockDynamoResults.new(
      [
        {
          "isbn": "9780451527172",
         "ask": 8.52,
         "vendor_uuid": "c225442c-8457-4665-8896-3af21a64ee25",
         "delivery_promise": "curbside-pickup"
        }
      ]
    )
  end
end
