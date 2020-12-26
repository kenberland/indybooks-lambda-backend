require 'json'
load 'git_commit_sha.rb'
load 'lib/dynamo_client.rb'

def purchases_handler(event:, context:)

  headers_list = {
    "Access-Control-Allow-Origin" => "*",
    "Indybooks-git-commit-sha" => $my_git_commit_sha
  }

  customer_uuid = event['pathParameters']['proxy'].split('/')[1]

  purchases = $purchase_manager.get(customer_uuid)

  ret = {
    :purchases => purchases.items
  }

  return { statusCode: 200,
           headers: headers_list,
           body: ret.to_json
  }

end
