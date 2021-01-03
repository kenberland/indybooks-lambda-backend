module PurchasesPost
  def purchases_post(event)
    lamda_result = purchases_post_handler(event: event, context: '')
    [
      lamda_result[:statusCode],
      lamda_result[:headers],
      lamda_result[:body]
    ]
  end
end

