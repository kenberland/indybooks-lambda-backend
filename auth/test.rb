require 'json'

def test_handler(event:, context:)
    # TODO implement
  { statusCode: 200, body: JSON.generate('Hello from Lambda!') }
end
