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

no_book_schema = {
  "type" => "object",
  "required" => ["errorType", "errorMessage", "trace", "quantity"],
  "properties" => {
    "errorType" => {
      "type" => "string"
    },
    "errorMessage" => {
      "type" => "string"
    },
    "trace" => {
      "type" => "array"
    },
    "quantity" => {
      "type" => "number"
    }
  }
}

unauthorized_schema = {
  "type" => "object",
  "required" => ["errorType", "errorMessage", "trace", "isbn", "ask",
                 "vendor_uuid", "delivery_promise", "quantity"],
  "properties" => {
    "errorType" => {
      "type" => "string"
    },
    "errorMessage" => {
      "type" => "string"
    },
    "trace" => {
      "type" => "array"
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

RSpec.describe '#auth_inventory_store_isbn' do
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

    describe 'when we dont have isbn credentials' do
      before(:each) do
        isbn = "%013d" % Integer(rand*10**13)
        store_uuid = SecureRandom.uuid
        event = {
          'pathParameters' => {
            'proxy' =>  "store/#{store_uuid}/isbn/#{isbn}"
          }
        }

        stub_request(:get, "#{ISBNDB_URL}/#{isbn}").
          to_return(status: 200, body: File.read('spec/mocks/unauthorized-message.json'))

        @lamda_result = auth_inventory_store_isbn_handler(event: event, context: '')
      end

      it 'json validates' do
        expect(
          JSON::Validator.fully_validate(unauthorized_schema,
                                         JSON.parse(@lamda_result[:body]),
                                         :strict => true
                                        )
        ).to eq []
      end

      it 'returns an "unauthorized" message' do
        expect(
          JSON.parse(@lamda_result[:body])["errorMessage"]
        ).to eq ISBNDB_CREDS_ERROR_STR
      end
    end

    describe 'when there is a isbn netork issue' do
      before(:each) do
        isbn = "%013d" % Integer(rand*10**13)
        store_uuid = SecureRandom.uuid
        event = {
          'pathParameters' => {
            'proxy' =>  "store/#{store_uuid}/isbn/#{isbn}"
          }
        }

        stub_request(:get, "#{ISBNDB_URL}/#{isbn}").
          to_timeout

        @lamda_result = auth_inventory_store_isbn_handler(event: event, context: '')
      end

      it 'json validates' do
        expect(
          JSON::Validator.fully_validate(unauthorized_schema,
                                         JSON.parse(@lamda_result[:body]),
                                         :strict => true
                                        )
        ).to eq []
      end

      it 'returns a "network error" message' do
        expect(
          JSON.parse(@lamda_result[:body])["errorMessage"]
        ).to eq ISBNDB_NETWORK_ERROR_STR
      end
    end

    describe 'when isbndb doesnt have the book' do
      before(:each) do
        isbn = "%013d" % Integer(rand*10**13)
        store_uuid = SecureRandom.uuid
        event = {
          'pathParameters' => {
            'proxy' =>  "store/#{store_uuid}/isbn/#{isbn}"
          }
        }

        stub_request(:get, "#{ISBNDB_URL}/#{isbn}").
          to_return(status: 200, body: File.read('spec/mocks/not-found.json'))

        $offer_manager.has_results = false

        @lamda_result = auth_inventory_store_isbn_handler(event: event, context: '')
      end


      it 'json validates' do
        expect(
          JSON::Validator.fully_validate(no_book_schema,
                                         JSON.parse(@lamda_result[:body]),
                                         :strict => true
                                        )
        ).to eq []
      end
    end

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

        it 'json validates' do
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

        it 'json validates' do
          expect(
            JSON::Validator.fully_validate(inventory_schema,
                                           JSON.parse(@lamda_result[:body]),
                                           :strict => true
                                          )
          ).to eq []
        end

        it 'quantity is greater zero' do
          expect(
            JSON.parse(@lamda_result[:body])['quantity']
          ).to be > 0
        end

      end
    end
  end
end
