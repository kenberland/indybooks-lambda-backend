root = File.expand_path("..", File.dirname(__FILE__))
$LOAD_PATH.unshift(root) unless $LOAD_PATH.include?(root)

require 'index'

RSpec.describe '#lambda index' do
  context 'lambda_result' do

    before(:all) do
      @lamda_result = handler(event: '', context: '')
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
