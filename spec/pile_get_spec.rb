load 'spec_helper.rb'
require 'lambda/auth/pile/get'
require 'json-schema'
require 'lib/schema/pile_get'

RSpec.describe '#pile_get' do
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
    let(:pile_uuid_params) { {
                        'pathParameters' => {
                          'proxy' =>  pile_uuid
                        }

                      }
    }
    let(:event) { {}.
                    merge(claims_context).
                    merge(pile_uuid_params) }
    let(:lambda_result) { auth_pile_handler(event: event, context: '') }

    describe 'for the get response' do
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

    describe 'with the right user' do
      it 'returns 200' do
        expect(lambda_result[:statusCode]).
          to eq 200
      end
    end

    describe 'without a uuid' do
      let(:pile_uuid) { {} }
      it 'returns 400' do
        expect(lambda_result[:statusCode]).
          to eq 400
      end
    end

    describe 'with a malformed uuid' do
      let(:pile_uuid) { {
                          'pathParameters' => {
                            'proxy' =>  '123455'
                          }
                        }
      }
      it 'returns 400' do
        expect(lambda_result[:statusCode]).
          to eq 400
      end
    end

    describe 'with a uuid for which there are no results' do
      let(:pile_uuid) { 'ed6b1ddd-598a-4607-b699-8cb8be91d90c' }
      it 'returns 404' do
        expect(lambda_result[:statusCode]).
          to eq 404
      end
    end

    describe 'with the wrong user' do
      let(:username) { 'foobar' }
      it 'returns 403' do
        expect(lambda_result[:statusCode]).
          to eq 403
      end
    end

    describe 'the response body' do
      it 'the json lints' do
        expect(
          JSON::Validator.fully_validate(PileGetSchema.schema,
                                         JSON.parse(lambda_result[:body]),
                                         :strict => true
                                        )
        ).to eq []
      end
    end
  end
end
