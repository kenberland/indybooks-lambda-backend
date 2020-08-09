require 'json'
load 'git_commit_sha.rb'
load 'lib/dynamo_client.rb'

def handler(event:, context:)

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

  stores_list = {
    "stores": [
                {
                  "id": 1,
                 "name": "Mrs Dalloway's",
                 "address": "2904 College Ave",
                 "city": "Berkeley",
                 "state": "CA",
                 "zip": "94705",
                 "area_code": "510",
                 "phone": "704-8222",
                },
                {
                  "id": 2,
                 "name": "Sleepy Cat Books",
                 "address": "2509 Telegraph Ave",
                 "city": "Berkeley",
                 "state": "CA",
                 "zip": "94704",
                 "area_code": "925",
                 "phone": "258-9076"
                },
                {
                  "id": 3,
                 "name": "Dog Eared Books",
                 "address": "900 Valencia St",
                 "city": "San Francisco",
                 "state": "CA",
                 "zip": "94110",
                 "area_code": "415",
                 "phone": "282-1901"
                }
              ]
  }

  return { statusCode: 200,
           headers: headers_list,
           body: "#{stores_list.to_json}"
  }

end
