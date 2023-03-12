module Satisfactory
  module Helpers
    def compact_blank(collection)
      case collection
      when Hash
        collection.compact.reject { |_, value| blank?(value) }
      when Array
        collection.compact.reject(&method(:blank?))
      else
        collection
      end
    end

    def blank?(value)
      case value
      when Hash, Array, String
        value.empty?
      when NilClass, FalseClass
        true
      else
        false
      end
    end
  end
end
