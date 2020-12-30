module AuthMyStores
  def auth_my_stores(event)
    lamda_result = auth_my_stores_handler(event: event, context: '')
    [
      lamda_result[:statusCode],
      lamda_result[:headers],
      lamda_result[:body]
    ]
  end
end

