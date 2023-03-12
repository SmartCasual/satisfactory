module Satisfactory
  # Provides a DSL for delegating methods to another object.
  #
  # @api private
  module Delegation
    # @api private
    def self.included(base)
      base.extend(ClassMethods)
    end

    # @api private
    module ClassMethods
      # @api private
      def delegate(*methods, to:)
        methods.each do |method|
          define_method(method) do |*args, **kwargs|
            send(to).public_send(method, *args, **kwargs)
          end
        end
      end
    end
  end
end
