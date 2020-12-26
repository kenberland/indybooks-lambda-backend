require 'json'
load 'git_commit_sha.rb'

def purchases_post_handler(event:, context:)

  headers_list = {
    "Access-Control-Allow-Origin" => "*",
    "Indybooks-git-commit-sha" => $my_git_commit_sha
  }

  post_body = event['pathParameters']['post_body']

  payload = JSON.parse(post_body, object_class: OpenStruct)
  ret = $purchase_manager.put(payload.purchase)

  return { statusCode: 200,
           headers: headers_list,
           body: ret.to_json
  }

end
