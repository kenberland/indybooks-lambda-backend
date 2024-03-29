load 'spec_helper.rb'
require 'lambda/auth/pile/post'
require 'json-schema'
require 'lib/schema/pile_post'
require 'lib/helpers'

RSpec.describe '#pile_post' do
  context 'lambda_result' do
    let(:username) { {
                       'requestContext' => {
                         'authorizer' => {
                           'claims' => {
                             'cognito:username' => 'indybooks'
                           }
                         }
                       }
                     }
    }
    let(:event) { { 'body' =>  File.read(post_file) }.merge(username) }
    let(:lambda_result) { piles_post_handler(event: event, context: '') }
    let(:post_file) {'spec/mocks/pile/valid-post.json'}

    describe 'for the post response' do
      it 'returns a well-formed response for Lambda' do
        expect(lambda_result.class).to eq Hash
      end

      it 'has 3 keys' do
        expect(lambda_result.keys.size).to eq 3
      end

      it 'body is a string' do
        expect(lambda_result[:body].class).to eq String
      end

      it 'body is a JSON string' do
        expect(JSON.parse(lambda_result[:body]).class).to eq Hash
      end
    end

    describe 'for the post body' do
      describe 'for a valid pile post' do
        it 'it succeeds' do
          expect(lambda_result[:statusCode]).to eq 200
        end
        it 'returns a uuid' do
          expect(JSON.parse(lambda_result[:body])['uuid']).
            to match UUID_REGEX
        end
      end


      describe 'for invalid pile posts' do
        describe 'with missing properties' do
          let(:post_file) { 'spec/mocks/pile/missing-list.json' }
          it 'does not lint' do
            expect(lambda_result[:statusCode]).to eq 400
          end
          it 'returns an empty body' do
            expect(lambda_result[:body]).to eq '{}'
          end
        end
        describe 'with extra properties' do
          let(:post_file) { 'spec/mocks/pile/added-foo.json' }
          it 'does not lint' do
            expect(lambda_result[:statusCode]).to eq 400
          end
        end
        describe 'with invalid json' do
          let(:post_file) { 'spec/mocks/pile/invalid.json' }
          it 'does not lint' do
            expect(lambda_result[:statusCode]).to eq 400
          end
        end
      end
    end
  end
end
