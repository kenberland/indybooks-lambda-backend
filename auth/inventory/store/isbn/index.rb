require 'json'

def auth_inventory_store_isbn_handler(event:, context:)
  headers_list = {
    "Access-Control-Allow-Origin" => "*",
    "Indybooks-git-commit-sha" => $my_git_commit_sha
  }

  store_uuid = event['pathParameters']['proxy'].split('/')[1]
  isbn = event['pathParameters']['proxy'].split('/')[3]

  book_json = isbn_http_get(isbn)
  book = JSON.parse(book_json)

  inventory = book.dup
#              "store_uuid": store_uuid,
#              "asking price": "$8.13",
#             "delivery promise": "24HD",
#             "quantity on hand": 2,

  { statusCode: 200, headers: headers_list, body: inventory.to_json }
end


def isbn_http_get(isbn)
  require 'net/http'
  uri = URI("https://api2.isbndb.com/book/#{isbn}")
  req = Net::HTTP::Get.new(uri)
  req['Authorization'] = '44900_f3d9d272dc11249cb7928da98b67a438'
  response = Net::HTTP.start(uri.host, uri.port,
                             :use_ssl => uri.scheme == 'https') {|http|
    http.request(req)
  }
  response.body
end
