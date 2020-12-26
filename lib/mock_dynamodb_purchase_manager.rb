require 'time'

class MockDynamodbPurchaseManager
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

  def get(customer_uuid)
    records = Integer(rand*3) + 1
    ret = []
    records.times do
      ret << {
        'customer_uuid': SecureRandom.uuid,
              'vendor_uuid': SecureRandom.uuid,
              'isbn': Integer(rand*10**10),
              'price': (Integer(rand*1000)+500)/100.0, # $5 - $15.00
              'delivery_promise': (rand > 0.5 ? '24hHD' : '1hPU'),
              'created_at': Time.now.utc.iso8601
      }
    end
    MockDynamoResults.new(ret)
  end
end
