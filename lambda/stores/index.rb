require 'json'
load 'git_commit_sha.rb'
load 'lib/dynamo_client.rb'

def stores_handler(event:, context:)

  headers_list = {
    "Access-Control-Allow-Origin" => "*",
    "Indybooks-git-commit-sha" => $my_git_commit_sha
  }

  lat = event['pathParameters']['proxy'].split('/')[1]
  long = event['pathParameters']['proxy'].split('/')[3]

  ret = {}

  stores = $store_manager.get_stores(lat.to_f, long.to_f)

  ret[:stores] = stores.map do |store|
    store.to_h
  end

  return { statusCode: 200,
           headers: headers_list,
           body: ret.to_json
  }

end
