class AuthMyPileGetSchema
  def self.schema
    foo = {
      type: :object,
      required: [:piles],
      properties: {
        piles: {
          type: :object,
          required: %w/username updated_at created_at pile_uuid_list/,
          properties: {
            isbn: {
              type: :arry,
              items: {
                type: :string,
                pattern: "[0-9a]"
              }
            }
          }
        }
      }
    }
  end
end
