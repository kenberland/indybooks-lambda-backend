require 'json'
load 'git_commit_sha.rb'
load 'lib/dynamo_client.rb'
require 'json-schema'
require 'schema/purchase_post'

OK = 200
BAD_REQUEST = 400
SERVER_ERROR = 500

def purchases_post_handler(event:, context:)

  headers_list = {
    "Access-Control-Allow-Origin" => "*",
    "Indybooks-git-commit-sha" => $my_git_commit_sha
  }

  payload = event['body']

  status = JSON::Validator.validate(PurchasePostSchema.schema, payload
                                   ) ? OK : BAD_REQUEST
  if status == OK
    payload = JSON.parse(payload, object_class: OpenStruct)
    ret_obj = $purchase_manager.put(payload.purchase)
    status = SERVER_ERROR unless ret_obj.data.class == Aws::DynamoDB::Types::PutItemOutput
  end

  ret = {
    "status": status
  }

  return { statusCode: status,
           headers: headers_list,
           body: ret.to_json
  }

end
