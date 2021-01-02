class InventoryStoreIsbnPutSchema
  def self.schema
    purchase_post_schema = {
      "type" => "object",
      "required" => ["book"],
      "properties" => {
        "book" => {
          "type" => "object",
          "required" => ["ask", "delivery_promise", "quantity"],
          "properties" => {
            "ask" => {
              "type" => "number",
            },
            "delivery_promise" => {
              "type" => "string"
            },
            "quantity" => {
              "type" => "number"
            },
          }
        }
      }
    }
  end
end
