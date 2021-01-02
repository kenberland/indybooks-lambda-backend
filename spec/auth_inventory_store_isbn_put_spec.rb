load 'spec_helper.rb'
require 'auth/inventory/store/isbn/put'
require 'json-schema'
require 'lib/schema/purchase_post'

RSpec.describe '#auth_inventory_store_isbn_put' do

  let(:event) {
    {
      'pathParameters' => {
        'proxy' =>  "store/#{store_uuid}/isbn/#{isbn}"
      }
    }
  }
  let(:store_uuid) { SecureRandom.uuid }
  let(:isbn) { Integer(rand*10**10) }


  context 'lambda_result' do

    describe 'for the PUT response' do
      before(:each) do
        event['body'] = File.read('spec/mocks/auth/inventory/store/isbn/valid-put.json')
        @lamda_result = auth_inventory_store_isbn_put_handler(event: event, context: '')
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
    end

    describe 'for the post body' do
      describe 'for a valid inventory post' do
        it 'it succeeds' do
          event['body'] = File.read('spec/mocks/auth/inventory/store/isbn/valid-put.json')
          @lamda_result = auth_inventory_store_isbn_put_handler(event: event, context: '')
          expect(@lamda_result[:statusCode]).to eq 200
        end
      end

      describe 'for invalid purchase posts' do
        describe 'it fails' do
          it 'for json that is missing a property' do
            event['body'] = File.read('spec/mocks/auth/inventory/store/isbn/missing-ask.json')
            @lamda_result = auth_inventory_store_isbn_put_handler(event: event, context: '')
            expect(@lamda_result[:statusCode]).to eq 400
          end

          it 'for json that has extra fields' do
            event['body'] = File.read('spec/mocks/auth/inventory/store/isbn/extra-property.json')
            @lamda_result = auth_inventory_store_isbn_put_handler(event: event, context: '')
            expect(@lamda_result[:statusCode]).to eq 400
          end

          it 'for invalid json' do
            event['body'] = File.read('spec/mocks/auth/inventory/store/isbn/invalid.json')
            @lamda_result = auth_inventory_store_isbn_put_handler(event: event, context: '')
            expect(@lamda_result[:statusCode]).to eq 400
          end
        end
      end
    end
  end
end
