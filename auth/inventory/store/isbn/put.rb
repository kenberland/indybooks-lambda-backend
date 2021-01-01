require 'json'
require 'git_commit_sha.rb'
require 'lib/dynamo_client.rb'
require 'lib/isbndb_client.rb'

def auth_inventory_store_isbn_put_handler(event:, context:)
  headers_list = {
    "Access-Control-Allow-Origin" => "*",
    "Indybooks-git-commit-sha" => $my_git_commit_sha
  }

  vendor_uuid = event['pathParameters']['proxy'].split('/')[1]
  isbn = event['pathParameters']['proxy'].split('/')[3]

  post_body = event['body']

  payload = JSON.parse(post_body, object_class: OpenStruct)

  ddb = $offer_manager.put(isbn, vendor_uuid, payload.book)

  puts "PUTing vendor: #{vendor_uuid} isbn: #{isbn}, #{payload.inspect}, #{ddb.inspect}"

  { statusCode: 200, headers: headers_list, body: ddb.to_json }
end

