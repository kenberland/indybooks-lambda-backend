load 'spec_helper.rb'
require 'lambda/auth/pile/delete'

RSpec.describe '#auth_pile_delete' do

  context 'lambda_result' do
    let(:pile_uuid) { SecureRandom.uuid }
    let(:pile_uuid_params) { {
                               'pathParameters' => {
                                 'proxy' =>  pile_uuid
                               }
                             }
    }
    let(:event) { {}.merge(pile_uuid_params) }
    let(:lambda_result) { auth_pile_delete_handler(event: event, context: '') }

    describe 'for the delete response' do
      it_behaves_like 'lambda function'
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
      it 'returns no body' do
        expect(lambda_result[:body]).
          to eq '{}'
      end
    end

    describe 'for a deleted pile' do
      it 'returns 200' do
        expect(lambda_result[:statusCode]).
          to eq 200
      end
      it 'returns no body' do
        expect(lambda_result[:body]).
          to eq '{}'
      end
    end
  end
end

