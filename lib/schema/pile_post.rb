class PilePostSchema
  def self.schema
    {
      type: :object,
      required: ["pile"],
      properties: {
        pile: {
          type: :object,
          required: ["book_list"],
          properties: {
            book_list: {
              type: :array,
              items: {
                "$ref": "#/definitions/book_list" 
              }
            }
          }
        }
      },
    definitions: {
        book_list: {
          type: "object",
          required: %w/isbn title/,
          properties: {
            isbn: {
              type: :string,
              pattern: "[0-9]"
            },
            title: {
              type: :string
            }
          }
        }
      }
    }
  end
end
