require_relative "upstream_record_finder"

module Satisfactory
  # Represents a collection of homogenous records.
  class Collection < Array
    # @api private
    def initialize(*args, upstream:, **kwargs, &block)
      super(*args, **kwargs, &block)
      @upstream = upstream
    end

    # @api private
    attr_reader :upstream

    # @!method and
    #   Delegates to the upstream record.
    #   @return (see Satisfactory::Record#and)
    #   @see Satisfactory::Record#and
    # @!method create
    #   Delegates to the upstream record.
    #   @return (see Satisfactory::Record#create)
    #   @see Satisfactory::Record#create
    # @!method to_plan
    #   Delegates to the upstream record.
    #   @return (see Satisfactory::Record#to_plan)
    #   @see Satisfactory::Record#to_plan
    delegate :and, :create, :to_plan, to: :upstream

    # Calls {#with} on each entry in the collection.
    #
    # @return [Satisfactory::Collection]
    def with(...)
      self.class.new(map { |entry| entry.with(...) }, upstream:)
    end
    alias each_with with

    # Calls {#which_is} on each entry in the collection.
    #
    # @param (see Satisfactory::Record#which_is)
    # @return [Satisfactory::Collection]
    def which_are(...)
      self.class.new(map { |entry| entry.which_is(...) }, upstream:)
    end
    alias which_is which_are

    # (see Satisfactory::Record#and_same)
    def and_same(upstream_type)
      Satisfactory::UpstreamRecordFinder.new(upstream:).find(upstream_type)
    end
    alias return_to and_same

    # @api private
    def build
      flat_map(&:build)
    end

    # @api private
    def build_plan
      flat_map(&:build_plan)
    end
  end
end
