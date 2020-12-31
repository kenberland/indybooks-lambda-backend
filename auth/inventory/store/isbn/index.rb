require 'json'
require 'git_commit_sha.rb'
require 'lib/dynamo_client.rb'

def auth_inventory_store_isbn_handler(event:, context:)
  headers_list = {
    "Access-Control-Allow-Origin" => "*",
    "Indybooks-git-commit-sha" => $my_git_commit_sha
  }

  vendor_uuid = event['pathParameters']['proxy'].split('/')[1]
  isbn = event['pathParameters']['proxy'].split('/')[3]

  book_json = isbn_http_get(isbn)
  book = JSON.parse(book_json)

  ddb = $offer_manager.query(isbn, vendor_uuid)

  if ddb.items.empty?
    items = {
      quantity: 0
    }
  else
    items = ddb.items.first.transform_values do |value|
      value.class == BigDecimal ? value.to_f : value
    end
    items.merge!({
                   quantity: 1
                 }
                )
  end

  book.merge!(items)

  { statusCode: 200, headers: headers_list, body: book.to_json }
end


def isbn_http_get(isbn)
  require 'net/http'
  uri = URI("https://api2.isbndb.com/book/#{isbn}")
  req = Net::HTTP::Get.new(uri)
  req['Authorization'] = ENV['ISBN_SECRET']
  response = Net::HTTP.start(uri.host, uri.port,
                             :use_ssl => uri.scheme == 'https') {|http|
    http.request(req)
  }
  response.body
end
