Uses rvm.

See the unified local DDB thingy at https://github.com/kenberland/indybooks/blob/master/ddb-local/README.md

You need a local DDB server in docker:

```
docker run -d -p 8000:8000 amazon/dynamodb-local
cd $HOME/indybooks/collectorz.com
INDY_ENV=development INDY_AUTH_USERNAME=indybooks AWS_REGION=us-east-2 AWS_ACCESS_KEY_ID=foo AWS_SECRET_ACCESS_KEY=bar books-xml2ddb.rb
cd $HOME/indybooks/populate-stores
INDY_ENV=development INDY_AUTH_USERNAME=indybooks AWS_REGION=us-east-2 AWS_ACCESS_KEY_ID=foo AWS_SECRET_ACCESS_KEY=bar ./populate-stores.rb
cd $HOME/lambda-pipeline-repo
ISBN_SECRET=$(gpg -d creds/ISBN_SECRET.txt.gpg) INDY_ENV=development INDY_AUTH_USERNAME=indybooks AWS_REGION=us-east-2 AWS_ACCESS_KEY_ID=foo AWS_SECRET_ACCESS_KEY=bar rake
```


### To declare bankruptcy:
```
rvm gemset delete $(cat .ruby-gemset )
cd ..
cd lambda-pipeline-repo/
bundle
rspec -fd spec/
```

### To develop:
```
ISBN_SECRET=$(gpg -d creds/ISBN_SECRET.txt.gpg) INDY_ENV=development INDY_AUTH_USERNAME=indybooks AWS_REGION=us-east-2 AWS_ACCESS_KEY_ID=foo AWS_SECRET_ACCESS_KEY=bar ruby server.rb
```

## supports pry
```ruby
require 'pry'
...
binding.pry;1
```

### To run tests:

```
rspec -fd spec/
```
### To run one
```
rspec ./spec/controllers/groups_controller_spec.rb:42

```


### To start the local server:
```
ruby server.rb
```

Then `curl http://localhost:4567/stores`

### TODO:

- Maybe there's a way to move the `Access-Control-Allow-Origin` header from the business logic to the config? See [this post](https://alexharv074.github.io/2019/03/31/introduction-to-sam-part-iii-adding-a-proxy-endpoint-and-cors-configuration.html), which contains this snip:

```yaml
  Api:
    Cors:
      AllowMethods: "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
      AllowHeaders: "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
      AllowOrigin: "'*'"
```


  # Our template builds with SAM which does not currently support Lambda
  # integration only lambda proxy. Cors is not supported in API Gateway for this
  # integ.
  # See https://docs.aws.amazon.com/apigateway/latest/developerguide/set-up-lambda-proxy-integrations.html#api-gateway-simple-proxy-for-lambda-output-format
  # https://medium.com/carsales-dev/api-gateway-with-aws-sam-template-c05afdd9cafe

  # For errors see: https://aws.amazon.com/premiumsupport/knowledge-center/malformed-502-api-gateway/
  # https://indybooks-developer-pastes.s3.us-east-2.amazonaws.com/2020-08-01-10-46-20.png


