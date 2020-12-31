require 'net/http'
require 'json'

ISBNDB_URL = 'https://api2.isbndb.com/book'
ISBNDB_CREDS_ERROR_STR = "ISBN DB Credentials Missing or Invalid"

class IsbndbClient
  def self.isbn_http_get(isbn)
    uri = URI("#{ISBNDB_URL}/#{isbn}")
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = ENV['ISBN_SECRET']
    response = Net::HTTP.start(uri.host, uri.port,
                               :use_ssl => uri.scheme == 'https') {|http|
      http.request(req)
    }
    obj_response = JSON.parse(response.body)
    if obj_response["message"] == 'Unauthorized' # make it look the same as their other error
      return {
        "errorType" => "string",
        "errorMessage" => ISBNDB_CREDS_ERROR_STR,
        "trace": []
      }
    else
      return obj_response
    end
  end
end
