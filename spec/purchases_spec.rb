load 'spec_helper.rb'
require 'lambda/purchases/get'
require "json-schema"

purchases_schema = {
  "type" => "object",
  "required" => ["purchases"],
  "properties" => {
    "purchases" => {
      "type" => "array",
      "items" => {
        "type" => "object",
        "properties" => {
          "customer_uuid" => {
            "type" => "uuid"
          },
          "vendor_uuid" => {
            "type" => "uuid"
          },
          "isbn" => {
            "type" => "number"
          },
          "price" => {
            "type" => "number"
          },
          "delivery_promise" => {
            "type" => "string"
          },
          "created_at" => {
            "type" => "date-time"
          }
        }
      }
    }
  }
}

RSpec.describe '#purchases_get' do
  context 'lambda_result' do

    before(:all) do
      event = {
        'pathParameters' => {
          'proxy' =>  "customer_uuid/d487f93c-4617-11eb-b378-0242ac130002"
        }
      }
      @lamda_result = purchases_handler(event: event, context: '')
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

    it 'body has purchases key' do
      expect(JSON.parse(@lamda_result[:body]).keys).to include 'purchases'
    end

    it 'purchase has some purchases' do
      expect(JSON.parse(@lamda_result[:body])['purchases'].size).to be > 0
    end

    it 'purchases are well-formed' do
      expect(
        JSON::Validator.fully_validate(purchases_schema,
                                 JSON.parse(@lamda_result[:body]),
                                 :strict => true
                                )
      ).to eq []
    end
  end
end
