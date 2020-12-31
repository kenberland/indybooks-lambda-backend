require 'net/http'

ISBNDB_URL = 'https://api2.isbndb.com/book'

class IsbndbClient
  def self.isbn_http_get(isbn)
    uri = URI("#{ISBNDB_URL}/#{isbn}")
    req = Net::HTTP::Get.new(uri)
    req['Authorization'] = ENV['ISBN_SECRET']
    response = Net::HTTP.start(uri.host, uri.port,
                               :use_ssl => uri.scheme == 'https') {|http|
      http.request(req)
    }
    response.body
  end
end

#  {
#  "errorType": "string",
#  "errorMessage": "Not Found",
#  "trace": []
#}

  #  {"message"=>"Unauthorized"}

  # timeouts
