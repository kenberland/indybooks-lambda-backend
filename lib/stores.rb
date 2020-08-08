module Stores
  def stores_index(name)
    lamda_result = handler(event: '', context: '')
    [
      lamda_result[:statusCode],
      lamda_result[:headers],
      lamda_result[:body]
    ]
  end
end

