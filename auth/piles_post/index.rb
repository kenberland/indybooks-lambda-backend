require 'json'
load 'git_commit_sha.rb'
load 'lib/dynamo_client.rb'
require 'json-schema'
require 'lib/schema/pile_post'
require 'lib/helpers'

def piles_post_handler(event:, context:)

  headers_list = {
    "Access-Control-Allow-Origin" => "*",
    "Indybooks-git-commit-sha" => $my_git_commit_sha
  }

  uuid = SecureRandom.uuid
  payload = event['body']
  status = JSON::Validator.validate(PilePostSchema.schema, payload,
                                    :strict => true
                                   ) ? OK : BAD_REQUEST
  if status == OK
    payload = JSON.parse(payload, object_class: OpenStruct)
    payload.pile.uuid = uuid
    payload.pile.username = event['requestContext']['authorizer']['claims']["cognito:username"]
    ret_obj = $pile_manager.put(payload.pile)
    status = SERVER_ERROR unless ret_obj.data.class == Aws::DynamoDB::Types::PutItemOutput
  end

  ret = {
    "status": status,
    "uuid": uuid
  }

  return { statusCode: status,
           headers: headers_list,
           body: ret.to_json
  }

end
