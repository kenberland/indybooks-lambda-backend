require 'net/http'
require 'json'

ISBNDB_URL = 'https://api2.isbndb.com/book'
ISBNDB_CREDS_ERROR_STR = "ISBN DB Credentials Missing or Invalid"
ISBNDB_NETWORK_ERROR_STR = 'Network error calling ISBN DB'

class IsbndbClient
  def self.isbn_http_get(isbn)
    rewrite_message = nil
    obj_response = nil
    uri = URI("#{ISBNDB_URL}/#{isbn}")
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = ENV['ISBN_SECRET']
    begin
      response = Net::HTTP.start(uri.host, uri.port,
                                 :use_ssl => uri.scheme == 'https') {|http|
        http.request(req)
      }
      obj_response = JSON.parse(response.body)
    rescue
      rewrite_message = ISBNDB_NETWORK_ERROR_STR
    end
    if !obj_response.nil? and obj_response["message"] == 'Unauthorized'
      # make it look the same as their other error
      rewrite_message = ISBNDB_CREDS_ERROR_STR
    end
    unless rewrite_message.nil?
      return {
        "errorType" => "string",
        "errorMessage" => rewrite_message,
        "trace": []
      }
    else
      return obj_response
    end
  end
end
