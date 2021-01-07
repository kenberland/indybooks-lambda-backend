require 'json'
load 'git_commit_sha.rb'
require 'lib/user_stores_map'
require 'lib/helpers'

def auth_my_stores_handler(event:, context:)
  headers_list = {
    "Access-Control-Allow-Origin" => "*",
    "Indybooks-git-commit-sha" => $my_git_commit_sha
  }
  username = get_cognito_username(event)
  my_stores = {
    'stores': [$USER_STORES_MAP[username]]
  }
  { statusCode: 200, headers: headers_list, body: my_stores.to_json }
end
