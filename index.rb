require 'json'

def lambda_handler(event:, context:)
    
    stores_list = {
      "stores": [
        {
          "id": 1,
          "name": "Mrs Dalloway's",
          "address": "2904 College Ave",
          "city": "Berkeley",
          "state": "CA",
          "zip": "94705",
          "area_code": "510",
          "phone": "704-8222",
        },
        {
          "id": 2,
          "name": "Sleepy Cat Books",
          "address": "2509 Telegraph Ave",
          "city": "Berkeley",
          "state": "CA",
          "zip": "94704",
          "area_code": "925",
          "phone": "258-9076"
        },
        {
          "id": 3,
          "name": "Dog Eared Books",
          "address": "900 Valencia St",
          "city": "San Francisco",
          "state": "CA",
          "zip": "94110",
          "area_code": "415",
          "phone": "282-1901"
        }
      ]
    }
    { statusCode: 200, body: JSON.generate("#{stores_list.to_json}") }
end
