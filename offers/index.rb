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

  offers_list = {
    "offers": [
                {"ask"=>0.761e1,
                 "vendor_uuid"=>"637b5f84-5dfb-4754-acf0-c0fc5b7d7fa0",
                 "delivery_promise"=>"curbside-pickup",
                 "isbn"=>"9780520081987"
                },
                {
                  "ask"=>0.1034e2,
                  "vendor_uuid"=>"879539b7-39cf-4167-ac75-9e644e7e9060",
                  "delivery_promise"=>"curbside-pickup",
                  "isbn"=>"9780520081987"
                },
                {
                  "ask"=>0.681e1,
                  "vendor_uuid"=>"b8000330-ccff-4df7-850e-a71e498382aa",
                  "delivery_promise"=>"curbside-pickup",
                  "isbn"=>"9780520081987"
                },
                {
                  "ask"=>0.1232e2,
                  "vendor_uuid"=>"d9007490-a64f-4506-a181-a330c7b4a009",
                  "delivery_promise"=>"curbside-pickup",
                  "isbn"=>"9780520081987"
                }
              ]
  }

  return { statusCode: 200,
           headers: headers_list,
           body: "#{offers_list.to_json}"
  }

end
