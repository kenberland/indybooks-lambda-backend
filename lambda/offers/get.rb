require 'json'
load 'git_commit_sha.rb'
load 'lib/dynamo_client.rb'

def offers_handler(event:, context:)

  headers_list = {
    "Access-Control-Allow-Origin" => "*",
    "Indybooks-git-commit-sha" => $my_git_commit_sha
  }

  isbn = event['pathParameters']['proxy'].split('/')[1]
  vendors = event['pathParameters']['proxy'].split('/')[3].split(',')

  offers = vendors.map do |vendor| # until such time as O(n) fucks us
    ddb = $offer_manager.query(isbn, vendor)
    ddb.items.each do |item|
      item.transform_values! do |value|
        value.class == BigDecimal ? value.to_f : value
      end
    end
  end.flatten

  ret = {
    :offers => offers
  }
  return { statusCode: 200,
           headers: headers_list,
           body: ret.to_json
  }

end
