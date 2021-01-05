require 'json'
load 'git_commit_sha.rb'
load 'lib/dynamo_client.rb'
require 'lib/helpers'

def auth_my_pile_get_handler(event:, context:)

  headers_list = {
    "Access-Control-Allow-Origin" => "*",
    "Indybooks-git-commit-sha" => $my_git_commit_sha
  }

  username = get_cognito_username(event)
  user_pile = $user_pile_manager.get(username)
  unless user_pile.items.empty?
    status = OK
    ret = {
      user_pile: user_pile.items.first
    }
  else
    status = NOT_FOUND
    ret = {}
  end
  return { statusCode: status,
           headers: headers_list,
           body: ret.to_json
  }
end
