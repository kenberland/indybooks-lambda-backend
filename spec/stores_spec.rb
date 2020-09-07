load 'spec_helper.rb'
require 'stores/index'

RSpec.describe '#stores_index' do
  context 'lambda_result' do

    before(:all) do
      event = {
        'pathParameters' => {
          'proxy' =>  "lat/35/long/-122"
        }
      }
      @lamda_result = stores_handler(event: event, context: '')
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

    it 'body has stores key' do
      expect(JSON.parse(@lamda_result[:body]).keys).to include 'stores'
    end

    it 'stores has some stores' do
      expect(JSON.parse(@lamda_result[:body])['stores'].size).to be > 0
    end
  end
end
