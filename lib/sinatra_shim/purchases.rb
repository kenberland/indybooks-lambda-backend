module Purchases
  def purchases(event)
    lamda_result = purchases_handler(event: event, context: '')
    [
      lamda_result[:statusCode],
      lamda_result[:headers],
      lamda_result[:body]
    ]
  end
end

