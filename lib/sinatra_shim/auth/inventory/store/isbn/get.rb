module AuthInventoryStoreIsbn
  def auth_inventory_store_isbn(event)
    lamda_result = auth_inventory_store_isbn_handler(event: event, context: '')
    [
      lamda_result[:statusCode],
      lamda_result[:headers],
      lamda_result[:body]
    ]
  end
  def auth_inventory_store_isbn_put(event)
    lamda_result = auth_inventory_store_isbn_put_handler(event: event, context: '')
    [
      lamda_result[:statusCode],
      lamda_result[:headers],
      lamda_result[:body]
    ]
  end
end

