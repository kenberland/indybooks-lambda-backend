class MockDynamoResults
  attr_accessor :items
  def initialize(items)
    @items = items
  end
end

class MockDynamodbManager
  attr_accessor :client, :table_name
  def initialize(region:, table_name:, access_key_id: nil,
                 secret_access_key: nil,
                 session_token: nil,
                 profile_name: 'default', endpoint: nil)

    @table_name = table_name

    @client = {
      region:      region,
      endpoint:    endpoint
    }
  end
  def get_stores(lat, long)
    [
     Store.new( latitude: 40.69, longitude: -74.25, address: '100 Main St.', city: 'NY', state: 'NY', zip: 10012, area_code: 212, phone: 5551212, name: "Rob's Store", uuid:  SecureRandom.uuid ),
     Store.new( latitude: 32.9137264, longitude: -96.8077421, address: '13536 Preston Rd #100', city: 'Dallas', state: 'TX', zip: 75240, area_code: 972, phone: 9913396, name: "LDS Books", uuid:  SecureRandom.uuid )
    ]
  end
end

class MockDynamodbOfferManager
  attr_accessor :client, :table_name, :has_results
  def initialize(region:, table_name:, access_key_id: nil,
                 secret_access_key: nil,
                 session_token: nil,
                 profile_name: 'default', endpoint: nil)

    @table_name      = table_name

    @client = {
      region:      region,
      endpoint:    endpoint
    }
    @has_results = true
  end

  def has_results?
    @has_results
  end

  def query(isbn, vendor_uuid)
    if has_results?
      MockDynamoResults.new(
        [
          {
            "isbn": isbn,
           "ask": 8.52,
           "vendor_uuid": vendor_uuid,
           "delivery_promise": (rand > 0.5 ? '24hHD' : '1hPU')
          }
        ]
      )
    else
      MockDynamoResults.new([])
    end
  end
end
