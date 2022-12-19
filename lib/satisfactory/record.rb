require_relative "collection"
require_relative "upstream_record_finder"

module Satisfactory
  # Represents a usage of a type.
  #
  # @todo This whole class needs a tidy up
  class Record # rubocop:disable Metrics/ClassLength
    # @api private
    # @param type [Symbol] The type of record to create.  Must be a known factory.
    # @param factory_name [Symbol] The name of the factory to use (if different).
    # @param upstream [Satisfactory::Record, Satisfactory::Collection, Satisfactory::Root] The upstream record-ish.
    # @param attributes [Hash] The attributes to use when creating the record.
    def initialize(type:, factory_name: nil, upstream: nil, attributes: {})
      @factory_name = factory_name || type

      config = Satisfactory.factory_configurations[type]
      raise ArgumentError, "Unknown factory #{type}" unless config

      @type = config[:parent] || type
      @type_config = Satisfactory.factory_configurations[@type]
      @traits = []
      @upstream = upstream

      @attributes = attributes

      @associations = type_config.dig(:associations, :plural).each.with_object({}) do |name, hash|
        hash[name] = Satisfactory::Collection.new(upstream: self)
      end
    end

    # @api private
    attr_accessor :type, :type_config, :traits, :upstream, :factory_name, :attributes

    # Add an associated record to this record's build plan.
    #
    # @param count [Integer] The number of records to create.
    # @param downstream_type [Symbol] The type of record to create.
    # @param force [Boolean] Whether to force the creation of the record.
    #   For internal use only.  Use {#and} instead.
    # @param attributes [Hash] The attributes to use when creating the record.
    # @return [Satisfactory::Record, Satisfactory::Collection]
    def with(count = nil, downstream_type, force: false, **attributes) # rubocop:disable Style/OptionalArguments, Metrics/AbcSize, Metrics/MethodLength, Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity
      if singular?(downstream_type)
        if count && count > 1 # rubocop:disable Style/IfUnlessModifier
          raise ArgumentError, "Cannot create multiple of singular associations (e.g. belongs_to)"
        end

        add_singular_association(downstream_type, factory_name: downstream_type, force:, attributes:)
      elsif plural?(downstream_type) && (singular = singular_from_plural(downstream_type))
        add_plural_association(downstream_type, factory_name: singular, count:, force:, attributes:)
      elsif (config = Satisfactory.factory_configurations[downstream_type])
        singular = config[:parent] || downstream_type
        plural = plural_from_singular(singular)
        add_singular_for_plural_association(plural, singular:, factory_name: downstream_type, force:, attributes:)
      elsif (config = Satisfactory.factory_configurations[downstream_type.to_s.singularize])
        unless (parent = config[:parent])
          raise ArgumentError, "Cannot create multiple of singular associations (e.g. belongs_to)"
        end

        plural = plural_from_singular(parent)
        add_plural_association(plural, factory_name: downstream_type.to_s.singularize, count:, force:, attributes:)
      else
        raise ArgumentError, "Unknown association #{type}->#{downstream_type}"
      end
    end

    # Add a sibling record to the parent record's build plan.
    # e.g. adding a second user to a project.
    #
    # @param count [Integer] The number of records to create.
    # @param downstream_type [Symbol] The type of record to create.
    # @param attributes [Hash] The attributes to use when creating the record.
    # @return (see #with)
    def and(count = nil, downstream_type, **attributes) # rubocop:disable Style/OptionalArguments
      upstream.with(count, downstream_type, force: true, **attributes)
    end

    # Apply one or more traits to this record's build plan.
    #
    # @param *traits [Symbol, ...] The traits to apply.
    def which_is(*traits)
      traits.each { |trait| self.traits << trait }
      self
    end

    # Locate the nearest ancestor of the given type.
    #
    # @param upstream_type [Symbol] The type of ancestor to find.
    # @return [Satisfactory::Record, Satisfactory::Collection, Satisfactory::Root]
    def and_same(upstream_type)
      Satisfactory::UpstreamRecordFinder.new(upstream:).find(upstream_type)
    end

    # @api private
    def modify
      yield(self).upstream
    end

    # Trigger the creation of this tree's build plan.
    #
    # @return (see Satisfactory::Root#create)
    # @todo Check if we still need the upstream check.
    def create
      if upstream
        upstream.create
      else
        create_self
      end
    end

    # Construct this tree's build plan.
    #
    # @return [Hash]
    def to_plan
      if upstream
        upstream.to_plan
      else
        build_plan
      end
    end

    # @api private
    def build_plan
      {
        traits:,
      }.merge(associations_plan).compact_blank
    end

    # @api private
    # @return (see #reify)
    def build
      reify(:build)
    end

    # @api private
    # @return (see #reify)
    def create_self
      reify(:create)
    end

  private

    attr_reader :associations

    # @return [ApplicationRecord]
    def reify(method)
      FactoryBot.public_send(method, factory_name, *traits, attributes.merge(associations.transform_values(&:build)))
    end

    def associations_plan
      associations.transform_values(&:build_plan).compact_blank
    end

    def plural?(association_name)
      type_config.dig(:associations, :plural).include?(association_name)
    end

    def singular?(association_name)
      type_config.dig(:associations, :singular).include?(association_name)
    end

    def plural_from_singular(singular_association_name)
      type_config.dig(:associations, :plural).find do |name|
        singular_association_name.to_s == name.to_s.singularize
      end
    end

    def singular_from_plural(plural_association_name)
      Satisfactory.factory_configurations.keys.find do |name|
        plural_association_name.to_s == name.to_s.pluralize
      end
    end

    def add_singular_association(name, factory_name:, force: false, attributes: {})
      if force || associations[name].blank?
        associations[name] = self.class.new(type: name, factory_name:, upstream: self, attributes:)
      else
        associations[name]
      end
    end

    def add_plural_association(name, factory_name:, count: nil, force: false, attributes: {})
      count ||= 1
      singular_name = name.to_s.singularize.to_sym

      Satisfactory::Collection.new(upstream: self).tap do |new_associations|
        count.times do
          new_associations << self.class.new(type: singular_name, factory_name:, upstream: self, attributes:)
        end

        if force
          associations[name] << new_associations
        else
          associations[name] = new_associations
        end
      end
    end

    def add_singular_for_plural_association(name, singular:, factory_name:, force: false, attributes: {})
      if force || associations[name].empty?
        associations[name] << self.class.new(type: singular, factory_name:, upstream: self, attributes:)
      end

      associations[name].last
    end
  end
end
