load 'spec_helper.rb'
require 'lambda/auth/pile/put'
require 'json-schema'
require 'lib/schema/pile_post'
require 'lib/helpers'

RSpec.describe '#pile_put' do
  context 'lambda_result' do
    let(:claims_context)   { {
                               'requestContext' => {
                                 'authorizer' => {
                                   'claims' => {
                                     'cognito:username' => username
                                   }
                                 }
                               }
                             }
    }
    let(:pile_uuid_params) { {
                               'pathParameters' => {
                                 'proxy' =>  pile_uuid
                               }

                             }
    }
    let(:post_body)        { {
                               'body' =>  File.read(post_file)
                             }
    }
    let(:pile_uuid) { SecureRandom.uuid }
    let(:post_file) {'spec/mocks/pile/valid-post.json'}
    let(:username)  { 'indybooks' }
    let(:event) { {}.
                    merge(post_body).
                    merge(claims_context).
                    merge(pile_uuid_params) }
    let(:lambda_result) { auth_pile_put_handler(event: event, context: '') }

    describe 'for the put response' do
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

    describe 'for the put body' do
      describe 'for a valid pile put' do
        it 'it succeeds' do
          expect(lambda_result[:statusCode]).to eq 200
        end
      end

      describe 'for an attempt to update a pile owned by another user' do
        let(:username) { 'someotheruser' }
        it 'it is unauthorized' do
          expect(lambda_result[:statusCode]).to eq 403
        end
      end

      describe 'for invalid pile put' do
        describe 'with missing properties' do
          let(:post_file) { 'spec/mocks/pile/missing-list.json' }
          it 'does not lint' do
            expect(lambda_result[:statusCode]).to eq 400
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
