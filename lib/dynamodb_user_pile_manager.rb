require 'time'

class DynamodbUserPileManager
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
    @table_name = table_name

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

  def create_table
    create_table_impl unless @client.list_tables.table_names.include?(@table_name)
  end

  def create_table_impl
    @client.create_table({
                           key_schema: [
                             { attribute_name: 'username',  key_type: 'HASH' },
                           ],
                           attribute_definitions: [
                             { attribute_name: 'username',   attribute_type: 'S' },
                           ],
                           provisioned_throughput: {
                             read_capacity_units: 10,
                             write_capacity_units: 5,
                           },
                           table_name: @table_name
                         })
  end

  def add_pile_uuid(username, pile_uuid)
    params = {
      table_name: @table_name,
      key: {
        username: username
      },
      update_expression: 'SET #pile_uuid_list = list_append(:vals, #pile_uuid_list), #updated_at = :now',
      expression_attribute_names: { '#pile_uuid_list': 'pile_uuid_list',
                                    '#updated_at': 'updated_at'
                                  },
      expression_attribute_values: { ':vals': [pile_uuid],
                                     ':now': Time.now.utc.iso8601
                                   },
      return_values: 'UPDATED_NEW'
    }
    client.update_item(params)
  end

  def conditional_user_pile_create(p)
    begin
      @client.put_item(
        {
          table_name: @table_name,
          item: {
            username: p.username,
            pile_uuid_list: [p.pile_uuid],
            created_at: Time.now.utc.iso8601,
            updated_at: Time.now.utc.iso8601,
          },
          condition_expression: 'attribute_not_exists(username)'
        }
      )
      return true
    rescue Aws::DynamoDB::Errors::ConditionalCheckFailedException
      return false
    end
  end

  def get(username)
    client.query(
      {
        table_name: @table_name,
        key_condition_expression: "username = :username",
        expression_attribute_values: {
          ":username" => username
        }
      }
    )
  end
end
