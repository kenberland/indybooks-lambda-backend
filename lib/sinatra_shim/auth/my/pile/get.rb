module AuthMyPile
  def auth_my_pile_get(event)
    lamda_result = auth_my_pile_get_handler(event: event, context: '')
    [
      lamda_result[:statusCode],
      lamda_result[:headers],
      lamda_result[:body]
    ]
  end
end

