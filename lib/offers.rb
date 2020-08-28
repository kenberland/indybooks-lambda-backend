module Offers
  def offers
    lamda_result = offers_handler(event: '', context: '')
    [
      lamda_result[:statusCode],
      lamda_result[:headers],
      lamda_result[:body]
    ]
  end
end

