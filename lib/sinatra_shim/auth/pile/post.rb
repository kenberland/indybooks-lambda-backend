module AuthPilePost
  def auth_pile_post(event)
    lamda_result = piles_post_handler(event: event, context: '')
    [
      lamda_result[:statusCode],
      lamda_result[:headers],
      lamda_result[:body]
    ]
  end
end

