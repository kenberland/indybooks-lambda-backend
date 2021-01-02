class PilePostSchema
  def self.schema
    foo = {
      "type" => "object",
      "required" => ["pile"],
      "properties" => {
        "pile" => {
          "type" => "object",
          "required" => ["isbn"],
          "properties" => {
            "isbn" => {
              "type" => "array",
              "items" => {
                "type" => "string",
                "pattern": "[0-9a]"
              }
            }
          }
        }
      }
    }
  end
end
