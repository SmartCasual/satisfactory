require_relative "record"

module Satisfactory
  # The root of the factory graph.
  # This is where you begin creating records.
  class Root
    # @api private
    def initialize
      @root_records = Hash.new { |h, k| h[k] = [] }
    end

    # Add a top-level record to the root.
    # This is your entry point into the factory graph, and
    # the way to begin creating records.
    def add(factory_name, **attributes)
      raise FactoryNotDefinedError, factory_name unless Satisfactory.factory_configurations.key?(factory_name)

      Satisfactory::Record.new(
        type: factory_name,
        upstream: self,
        attributes:,
      ).tap { |r| @root_records[factory_name] << r }
    end

    # @api private
    # @return [Hash<Symbol, Array<T>>]
    def create
      @root_records.transform_values do |records|
        records.map(&:create_self)
      end
    end

    # @api private
    # @return [Hash<Symbol, Array<Hash>>]
    def to_plan
      @root_records.transform_values do |records|
        records.map(&:build_plan)
      end
    end

    # @api private
    # @return [nil]
    def upstream
      nil
    end

    # @api private
    class FactoryNotDefinedError < StandardError; end
  end
end
