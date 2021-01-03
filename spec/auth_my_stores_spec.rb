load 'spec_helper.rb'
require 'lambda/auth/my/stores/get'
require 'json-schema'

purchases_schema = {
  "type" => "object",
  "required" => ["stores"],
  "properties" => {
    "stores" => {
      "type" => "array",
      "items" => {
        "type" => "uuid"
      }
    }
  }
}

RSpec.describe '#auth_my_stores_get' do
  context 'lambda_result' do

    before(:all) do
      event = {
        'requestContext' => {
          'authorizer' => {
            'claims' => {
              'cognito:username' => 'indybooks'
            }
          }
        }
      }
      @lamda_result = auth_my_stores_handler(event: event, context: '')
    end

    it 'returns a well-formed response for Lambda' do
      expect(@lamda_result.class).to eq Hash
    end

    it 'has 3 keys' do
      expect(@lamda_result.keys.size).to eq 3
    end

    it 'body is a string' do
      expect(@lamda_result[:body].class).to eq String
    end

    it 'body is a JSON string' do
      expect(JSON.parse(@lamda_result[:body]).class).to eq Hash
    end

    it 'body has stores key' do
      expect(JSON.parse(@lamda_result[:body]).keys).to include 'stores'
    end

    it 'body is well formed' do
      expect(
        JSON::Validator.fully_validate(purchases_schema,
                                 JSON.parse(@lamda_result[:body]),
                                 :strict => true
                                )
      ).to eq []
    end
  end
end
