require 'time'

class MockDynamodbPileManager
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

  def put(p)
    MockDynamoSeahorse.new(Aws::DynamoDB::Types::PutItemOutput.new)
  end

  def get(uuid)
    return MockDynamoResults.new({}) if uuid == 'ed6b1ddd-598a-4607-b699-8cb8be91d90c'
    isbns = Integer(rand*10) + 1
    ret = []
    ret.push({
              "isbn" => isbns.times.map {Integer(rand * 10**9).to_s },
              "username" => 'indybooks'
             })
    MockDynamoResults.new(ret)
  end
end
