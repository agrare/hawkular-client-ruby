# It contains class definitions that are used by the inventory REST client
module Hawkular::InventoryV4
  class Metric
    # @return [String] Name of the metric
    attr_reader :name
    # @return [String] Type of the metric
    attr_reader :type
    # @return [Hash<String,String>] Properties of this metric
    attr_reader :properties

    def initialize(hash)
      @name = hash['name']
      @type = hash['type']
      @properties = hash['properties'] || {}
    end

    def hawkular_id
      @properties['hawkular.metric.id']
    end

    def hawkular_type
      @properties['hawkular.metric.type']
    end
  end

  class Operation
    # @return [String] Name of the operation
    attr_reader :name
    attr_reader :params

    def initialize(op_hash)
      @name = op_hash['name']
      @params = (op_hash.key? 'parameters') ? op_hash['parameters'] : {}
    end
  end

  class ResourceType
    # @return [String] Id of the resource type
    attr_reader :id
    # @return [Hash<String,String>] Properties of this resource type
    attr_reader :properties
    # @return [List<Operation>] Operations associated with this type
    attr_reader :operations

    def initialize(hash)
      @id = hash['id']
      @properties = hash['properties'] || {}
      @operations = (hash['operations'] || []).map { |op| Operation.new(op) }
      @_hash = hash.dup
    end

    def ==(other)
      self.equal?(other) || other.class == self.class && other.id == @id
    end

    # Returns a hash representation of the resource type
    # @return [Hash<String,Object>] hash of the resource type
    def to_h
      @_hash.dup
    end
  end

  class Resource
    # @return [String] Id of the entity
    attr_reader :id
    # @return [String] Name of the entity
    attr_reader :name
    # @return [String] Feed this entity belongs to
    attr_reader :feed
    # @return [ResourceType] Type of this resource
    attr_reader :type
    # @return [Hash<String,String>] Properties of this resource
    attr_reader :properties
    # @return [Hash<String,String>] Config map of this resource
    attr_reader :config
    # @return [List<Metric>] Metrics associated to this resource
    attr_reader :metrics
    # @return [List<Resource>] List of children (present when the whole tree is loaded, else nil)
    attr_reader :children

    def initialize(hash)
      @id = hash['id']
      @name = hash['name']
      @feed = hash['feedId']
      @type = ResourceType.new(hash['type'])
      @properties = hash['properties'] || {}
      @config = hash['config'] || {}
      @metrics = (hash['metrics'] || []).map { |m| Metric.new(m) }
      @children = hash['children'].map { |r| Resource.new(r) } if hash.key? 'children'
      @_hash = hash.dup
    end

    def ==(other)
      self.equal?(other) || other.class == self.class && other.id == @id
    end

    # Returns a hash representation of the resource
    # @return [Hash<String,Object>] hash of the resource
    def to_h
      @_hash.dup
    end
  end
end
