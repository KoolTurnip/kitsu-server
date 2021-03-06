module Errors
  class RailsModel
    def self.graphql_error(record)
      errors = record.errors.map do |attribute, message|
        {
          message: record.errors.full_message(attribute, message),
          path: ['attributes', attribute.to_s.camelize(:lower)]
        }
      end

      {
        errors: errors
      }
    end
  end
end
