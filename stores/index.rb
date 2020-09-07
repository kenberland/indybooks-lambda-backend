require 'json'
load 'git_commit_sha.rb'
load 'lib/dynamo_client.rb'

def stores_handler(event:, context:)

  # Our template builds with SAM which does not currently support Lambda
  # integration only lambda proxy. Cors is not supported in API Gateway for this
  # integ.
  # See https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-output-format
  # https://medium.com/carsales-dev/api-gateway-with-aws-sam-template-c05afdd9cafe

  # For errors see: https://aws.amazon.com/premiumsupport/knowledge-center/malformed-502-api-gateway/
  # https://indybooks-developer-pastes.s3.us-east-2.amazonaws.com/2020-08-01-10-46-20.png

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
