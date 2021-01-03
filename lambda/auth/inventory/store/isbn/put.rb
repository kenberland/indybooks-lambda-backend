require 'json'
require 'git_commit_sha.rb'
require 'lib/helpers'
require 'lib/dynamo_client.rb'
require 'lib/isbndb_client.rb'
require 'lib/schema/inventory_store_isbn_put'

def auth_inventory_store_isbn_put_handler(event:, context:)
  headers_list = {
    "Access-Control-Allow-Origin" => "*",
    "Indybooks-git-commit-sha" => $my_git_commit_sha
  }

  vendor_uuid = event['pathParameters']['proxy'].split('/')[1]
  isbn = event['pathParameters']['proxy'].split('/')[3]

  payload = event['body']

  status = JSON::Validator.validate(InventoryStoreIsbnPutSchema.schema,
                                    payload, :strict => true
                                   ) ? OK : BAD_REQUEST
  if status == OK
    payload = JSON.parse(payload, object_class: OpenStruct)
    ret_obj = $offer_manager.put(isbn, vendor_uuid, payload.book)
    status = SERVER_ERROR unless ret_obj.data.class == Aws::DynamoDB::Types::PutItemOutput
  end

  ret = {
    "status": status
  }

  { statusCode: status,
    headers: headers_list,
    body: ret.to_json }
end
