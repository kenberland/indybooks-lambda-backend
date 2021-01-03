load 'spec_helper.rb'
require 'lambda/offers/get'

RSpec.describe '#offers_get' do
  context 'lambda_result' do

    before(:all) do
      event = {
        'pathParameters' => {
          'proxy' =>  "isbn/12345/vendors/98,88"
        }
      }
      @lamda_result = offers_handler(event: event, context: '')
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

    it 'body has offers key' do
      expect(JSON.parse(@lamda_result[:body]).keys).to include 'offers'
    end

    it 'offers has some offers' do
      expect(JSON.parse(@lamda_result[:body])['offers'].size).to be > 0
    end
  end
end
