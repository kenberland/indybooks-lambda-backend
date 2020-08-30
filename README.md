Uses rvm.

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

### To run local dynamodb:
```
docker run -t -i --rm --network host amazon/dynamodb-local
```

### TODO:

- Maybe there's a way to move the `Access-Control-Allow-Origin` header from the business logic to the config? See [this post](https://alexharv074.github.io/2019/03/31/introduction-to-sam-part-iii-adding-a-proxy-endpoint-and-cors-configuration.html), which contains this snip:

```yaml
  Api:
    Cors:
      AllowMethods: "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
      AllowHeaders: "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
      AllowOrigin: "'*'"
```
