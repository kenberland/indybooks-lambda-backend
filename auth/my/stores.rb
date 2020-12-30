require 'json'

def handler(event:, context:)
  headers_list = {
    "Access-Control-Allow-Origin" => "*",
    "Indybooks-git-commit-sha" => $my_git_commit_sha
  }
  my_stores = {
    'stores' => ['5fa6f746-27b6-55b6-9c7d-193fdee21468']
  }
  { statusCode: 200, headers: headers_list, body: my_stores.to_json }
end
