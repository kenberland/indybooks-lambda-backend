load 'spec_helper.rb'
require 'auth/inventory/store/isbn/index'
require 'json-schema'

no_inventory_schema = {
  "type" => "object",
  "required" => ["book", "quantity"],
  "properties" => {
    "book" => {
      "type" => "object"
    },
    "quantity" => {
      "type" => "number"
    }
  }
}

inventory_schema = {
  "type" => "object",
  "required" => ["book", "isbn", "ask", "vendor_uuid", "delivery_promise", "quantity"],
  "properties" => {
    "book" => {
      "type" => "object"
    },
    "isbn" => {
      "type" => "string"
    },
    "vendor_uuid" => {
      "type" => "uuid"
    },
    "isbn" => {
      "type" => "string"
    },
    "ask" => {
      "type" => "number"
    },
    "delivery_promise" => {
      "type" => "string"
    },
    "quantity" => {
      "type" => "number"
    }
  }
}

RSpec.describe '#auth_my_stores_get' do
  context 'lambda_result' do

    describe 'the Lambda proxy' do
      before(:all) do

        isbn = "%013d" % Integer(rand*10**13)
        store_uuid = SecureRandom.uuid
        event = {
          'pathParameters' => {
            'proxy' =>  "store/#{store_uuid}/isbn/#{isbn}"
          }
        }

        stub_request(:get, "#{ISBNDB_URL}/#{isbn}").
          to_return(status: 200, body: '{}')

        @lamda_result = auth_inventory_store_isbn_handler(event: event, context: '')
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
    end

    # when they don't have the book
    # when not authorized
    # when times out

    describe 'when isbndb has the book' do
      before(:each) do
        isbn = "%013d" % Integer(rand*10**13)
        store_uuid = SecureRandom.uuid
        event = {
          'pathParameters' => {
            'proxy' =>  "store/#{store_uuid}/isbn/#{isbn}"
          }
        }

        stub_request(:get, "#{ISBNDB_URL}/#{isbn}").
          to_return(status: 200, body: File.read('spec/mocks/pepys.json'))

        @lamda_result = auth_inventory_store_isbn_handler(event: event, context: '')
      end

      describe 'and we do not have the book in inventory' do

        before(:all) do
          $offer_manager.has_results = false
        end

        it 'body is well formed' do
#          puts JSON.pretty_generate(JSON.parse(@lamda_result[:body]))
          expect(
            JSON::Validator.fully_validate(no_inventory_schema,
                                           JSON.parse(@lamda_result[:body]),
                                           :strict => true
                                          )
          ).to eq []
        end

        it 'quantity is zero' do
          expect(
            JSON.parse(@lamda_result[:body])['quantity']
          ).to eq 0
        end
      end

      describe 'and we have the book in inventory' do

        before(:all) do
          $offer_manager.has_results = true
        end

        it 'body is well formed' do
#          puts JSON.pretty_generate(JSON.parse(@lamda_result[:body]))
          expect(
            JSON::Validator.fully_validate(inventory_schema,
                                           JSON.parse(@lamda_result[:body]),
                                           :strict => true
                                          )
          ).to eq []
        end
      end
    end
  end
end
