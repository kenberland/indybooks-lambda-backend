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
  return { statusCode: status,
           headers: headers_list,
           body: {}.to_json
  } if status == BAD_REQUEST
  
  if status == OK
    username = get_cognito_username(event)
    payload = JSON.parse(payload, object_class: OpenStruct)
    payload.pile.uuid = uuid
    payload.pile.username = username
    ret_obj = $pile_manager.put(payload.pile)
    status = SERVER_ERROR unless ret_obj.data.class == Aws::DynamoDB::Types::PutItemOutput
    unless $user_pile_manager.conditional_user_pile_create(OpenStruct.new(
                                                             username: username,
                                                             pile_uuid: uuid)
                                                          )
      $user_pile_manager.add_pile_uuid(username, uuid)
    end
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
