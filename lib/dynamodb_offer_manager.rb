class DynamodbOfferManager
  attr_accessor :client, :table_name
  def initialize(region:, table_name:, access_key_id: nil,
                 secret_access_key: nil,
                 session_token: nil,
                 profile_name: 'default', endpoint: nil)
    if access_key_id.nil? && secret_access_key.nil?
      access_key_id = ENV['AWS_ACCESS_KEY_ID']
      secret_access_key = ENV['AWS_SECRET_ACCESS_KEY']
    end
    credentials = Aws::Credentials.new(access_key_id,
                                       secret_access_key,
                                       ENV['AWS_SESSION_TOKEN'])
    @table_name      = table_name

    if endpoint
      @client = Aws::DynamoDB::Client.new(
        region:      region,
        credentials: credentials,
        endpoint:    endpoint
      )
    else
      @client = Aws::DynamoDB::Client.new(
        region:      region,
        credentials: credentials,
      )
    end
  end

  def put(isbn, vendor_uuid, offer)
    @client.put_item(
      {
        table_name: @table_name,
        item: {
          'vendor_uuid' => vendor_uuid,
          'isbn'   => isbn,
          'price'   => offer.ask,
          'delivery_promise' => offer.delivery_promise,
          'quantity' => offer.quantity,
          'last_modified' => Time.now.utc.iso8601
        }
      }
    )
  end

  def query(isbn, vendor_uuid)
    begin
      client.query(
        {
          table_name: @table_name,
          :key_condition_expression => "isbn = :isbn and vendor_uuid = :vendor_uuid",
          expression_attribute_values: {
            ":isbn" => isbn,
            ":vendor_uuid" => vendor_uuid
          }
        }
      )
    rescue
      raise "Could not query #{@table_name}"
    end
  end

end
