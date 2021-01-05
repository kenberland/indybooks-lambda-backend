load 'spec_helper.rb'
require 'lambda/auth/my/pile/get'
require 'json-schema'
require 'lib/schema/auth_my_pile_get'

RSpec.describe '#auth_my_pile_get' do

  context 'lambda_result' do
    let(:username) { 'indybooks' }
    let(:pile_uuid) { SecureRandom.uuid }
    let(:claims_context) { {
                       'requestContext' => {
                         'authorizer' => {
                           'claims' => {
                             'cognito:username' => username
                           }
                         }
                       }
                     }
    }
    let(:event) { {}.merge(claims_context) }
    let(:lambda_result) { auth_my_pile_get_handler(event: event, context: '') }

    describe 'for the get response' do
      it_behaves_like 'lambda function'
    end

    describe 'for a user that has piles' do
      it 'returns 200' do
        expect(lambda_result[:statusCode]).
          to eq 200
      end
    end

    describe 'for a user with no piles' do
      let(:username) { 'foobar' }

      it 'returns 404' do
        expect(lambda_result[:statusCode]).
          to eq 404
      end
      it 'returns no body' do
        expect(lambda_result[:body]).
          to eq '{}'
      end
    end

    describe 'the response body' do
      it 'the json lints' do
        expect(
               JSON::Validator.fully_validate(AuthMyPileGetSchema.schema,
                                              JSON.parse(lambda_result[:body]),
                                              :strict => true
                                              )
               ).to eq []
      end
    end
  end
end
