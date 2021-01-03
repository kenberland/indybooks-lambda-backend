require 'time'

class MockDynamodbUserPileManager
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

  def conditional_user_pile_create(p)
    if (rand > 0.5)
      MockDynamoSeahorse.new(Aws::DynamoDB::Types::PutItemOutput.new)
    else
      false
    end
  end

  def add_pile_uuid(username, uuid)
    MockDynamoSeahorse.new(Aws::DynamoDB::Types::PutItemOutput.new)
  end

  def get(username)
    pile_uuids = Integer(rand*10) + 1
    ret = { username: username }
    ret.push({
              "pile_uuids" => isbns.times.map {Integer(rand * 10**9).to_s },
              "username" => 'indybooks'
             })
    MockDynamoResults.new(ret)
  end
end
