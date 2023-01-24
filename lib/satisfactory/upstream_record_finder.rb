module Satisfactory
  # Finds the upstream record of a given type.
  #
  # @api private
  class UpstreamRecordFinder
    def initialize(upstream:)
      @upstream = upstream
    end

    # @api private
    attr_accessor :upstream

    # @!method create
    #   Delegates to the upstream record.
    #   @return (see Satisfactory::Record#create)
    #   @see Satisfactory::Record#create
    # @!method with_new
    #   Delegates to the upstream record.
    #   @return (see Satisfactory::Record#with_new)
    #   @see Satisfactory::Record#with_new
    # @!method to_plan
    #   Delegates to the upstream record.
    #   @return (see Satisfactory::Record#with_new)
    #   @see Satisfactory::Record#with_new
    delegate :create, :with_new, :to_plan, to: :upstream

    # Find the upstream record of the given type.
    #
    # @api private
    # @param type [Symbol] The type of upstream record to find.
    # @return [Satisfactory::Record, Satisfactory::Collection, Satisfactory::Root]
    def find(type)
      raise MissingUpstreamRecordError, type if upstream.nil?

      if type == upstream.type
        self
      else
        self.upstream = upstream.upstream
        find(type)
      end
    end

    # (see Satisfactory::Record#with)
    def with(*args, **kwargs)
      upstream.with(*args, force: true, **kwargs)
    end

    # @api private
    class MissingUpstreamRecordError < StandardError; end
  end
end
