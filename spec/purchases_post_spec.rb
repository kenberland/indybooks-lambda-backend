load 'spec_helper.rb'
require 'lambda/purchases_post/index'
require 'json-schema'
require 'lib/schema/purchase_post'

RSpec.describe '#purchases_post' do
  context 'lambda_result' do

    describe 'for the post response' do

      before(:each) do
        event = {
          'body' =>  File.read('spec/mocks/purchases/valid-post.json')
        }
        @lamda_result = purchases_post_handler(event: event, context: '')
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

    describe 'for the post body' do

      describe 'for a valid purchase post' do
        before(:each) do
          event = {
            'body' =>  File.read('spec/mocks/purchases/valid-post.json')
          }
          @lamda_result = purchases_post_handler(event: event, context: '')
        end

        it 'it succeeds' do
          expect(@lamda_result[:statusCode]).to eq 200
        end
      end


      describe 'for invalid purchase posts' do
        describe 'it fails' do
          it 'for json that is missing the isbn property' do
            event = {
              'body' =>  File.read('spec/mocks/purchases/missing_isbn.json')
            }
            @lamda_result = purchases_post_handler(event: event, context: '')

            expect(@lamda_result[:statusCode]).to eq 400
          end

          it 'for json that has extra fields' do
            event = {
              'body' =>  File.read('spec/mocks/purchases/added-foo.json')
            }
            @lamda_result = purchases_post_handler(event: event, context: '')

            expect(@lamda_result[:statusCode]).to eq 400
          end

          it 'for invalid json' do
            event = {
              'body' =>  File.read('spec/mocks/purchases/invalid.json')
            }
            @lamda_result = purchases_post_handler(event: event, context: '')

            expect(@lamda_result[:statusCode]).to eq 400
          end
        end
      end
    end
  end
end
