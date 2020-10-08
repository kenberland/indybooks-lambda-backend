Uses rvm.
See the unified local DDB thingy at https://github.com/kenberland/indybooks/blob/master/ddb-local/README.md

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
export INDY_ENV=development
```


### To run tests:

```
rspec -fd spec/
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


cats
