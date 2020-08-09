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
