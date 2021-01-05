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
    if username == 'indybooks'
      n_piles = Integer(rand*10) + 1
      ret = [{
               username: username,
               updated_at: Time.now.utc.iso8601,
               created_at: Time.now.utc.iso8601,
               pile_uuid_list: n_piles.times.map { SecureRandom.uuid }
             }]
    else
      ret = {}
    end
      MockDynamoResults.new(ret)
  end
end


# {
#   "piles": {
#     "username": "indybooks",
#     "pile_uuid_list": [
#       "a027aabd-3318-4dd4-8fb4-8dc4d86c0dbf",
#       "57223548-6cf8-4e21-a56a-441fab8df326",
#       "28d393a9-bf34-46c1-9b6c-d534d0b535f2",
#       "efbe66d9-e7ed-498c-baf5-40d0e4cdb8f3"
#     ],
#     "updated_at": "2021-01-05T03:12:53Z",
#     "created_at": "2021-01-05T02:01:06Z"
#   }
# }
