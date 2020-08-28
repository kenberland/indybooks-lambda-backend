module Offers
  def offers
    $offer_manager.query('9780520081987')
    
    lamda_result = handler(event: '', context: '')
    [
      lamda_result[:statusCode],
      lamda_result[:headers],
      lamda_result[:body]
    ]
  end
end

