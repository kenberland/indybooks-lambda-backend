require 'time'

class DynamodbPileManager
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
                             { attribute_name: 'pile_uuid',  key_type: 'HASH' }
                           ],
                           attribute_definitions: [
                             { attribute_name: 'pile_uuid',    attribute_type: 'S' }
                           ],
                           provisioned_throughput: {
                             read_capacity_units: 10,
                             write_capacity_units: 5,
                           },
                           table_name: @table_name
                         })
  end

  def delete(pile_uuid)
    params = {
      table_name: @table_name,
      key: {
        pile_uuid: pile_uuid
      },
      return_consumed_capacity: "INDEXES",
      return_item_collection_metrics: "SIZE"
    }
    client.delete_item(params)
  end

  def put(p)
    @client.put_item(
      {
        table_name: @table_name,
        item: {
          'pile_uuid' => p.uuid,
          'username' => p.username,
          'book_list' => p.book_list,
          'created_at' => Time.now.utc.iso8601
        }
      }
    )
  end

  def get(pile_uuid) ##uid is a reserved word
    client.query(
      {
        table_name: @table_name,
        key_condition_expression: "pile_uuid = :pile_uuid",
        expression_attribute_values: {
          ":pile_uuid" => pile_uuid
        }
      }
    )
  end
end
