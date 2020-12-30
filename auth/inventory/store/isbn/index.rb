require 'json'

def auth_inventory_store_isbn_handler(event:, context:)
  headers_list = {
    "Access-Control-Allow-Origin" => "*",
    "Indybooks-git-commit-sha" => $my_git_commit_sha
  }

  store_uuid = event['pathParameters']['proxy'].split('/')[1]
  isbn = event['pathParameters']['proxy'].split('/')[3]

  inventory = {
    "book": {
              "store_uuid": store_uuid,
              "asking price": "$8.13",
             "delivery promise": "24HD",
             "quantity on hand": 2,
             "publisher": "Modern Library",
             "image": "https://images.isbndb.com/covers/07/15/9780812970715.jpg",
             "authors": [
                          "Pepys, Samuel"
                        ],
             "title": "The Diary of Samuel Pepys (Modern Library Classics)",
             "isbn": isbn,
             "msrp": "18",
             "binding": "Paperback",
             "publish_date": "2003-09-09T00:00:01Z",
            }
  }
  { statusCode: 200, headers: headers_list, body: inventory.to_json }
end
