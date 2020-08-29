To run tests

```
rspec -fd spec/
```

To start the local server
```
ruby server.rb
```

or
```
AWS_REGION=us-east-2 AWS_ACCESS_KEY_ID=foo AWS_SECRET_ACCESS_KEY=bar ruby server.rb
```

Then `curl http://localhost:4567/stores`

## setup a local dynamodb

docker run -t -i --rm --network host amazon/dynamodb-local


TODO:
https://alexharv074.github.io/2019/03/31/introduction-to-sam-part-iii-adding-a-proxy-endpoint-and-cors-configuration.html
  Api:
+    Cors:
+      AllowMethods: "'DELETE,GET,HEAD,OPTIONS,PATCH,POST,PUT'"
+      AllowHeaders: "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'"
+      AllowOrigin: "'*'"