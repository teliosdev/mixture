# encoding: utf-8

require "thread_safe"

module Mixture
  # Contains information about types.
  module Types
    # A list of all of the types (non-anonymous) that are known.
    #
    # @return [Array<Class>]
    def self.types
      @types ||= ThreadSafe::Array.new
    end

    # A list of the aliases that all types have.
    def self.mappings
      ::Hash[types.flat_map do |type|
        type.mappings.map do |name|
          [name, type]
        end
      end]
    end

    # Infers an object's type.
    def self.infer(object)
      mappings.fetch(object) do
        if object.is_a?(::Class)
          infer_class(object)
        else
          infer_type(object)
        end
      end
    end

    def self.infer_class(object)
      return object if object <= Type
      types.find { |type| type.options[:primitive] == object } || Class[object]
    end

    def self.infer_type(object)
      case object
      when ::Array then Array[infer(object.first)]
      when ::Set   then Set[infer(object.first)]
      else types.reverse.find { |type| type.matches?(object) }
      end
    end
  end
end

require "mixture/types/type"
require "mixture/types/access"
require "mixture/types/object"
require "mixture/types/enumerable"
require "mixture/types/collection"
require "mixture/types/class"
require "mixture/types/boolean"
require "mixture/types/numeric"
require "mixture/types/array"
require "mixture/types/date"
require "mixture/types/datetime"
require "mixture/types/float"
require "mixture/types/hash"
require "mixture/types/integer"
require "mixture/types/nil"
require "mixture/types/rational"
require "mixture/types/set"
require "mixture/types/string"
require "mixture/types/symbol"
require "mixture/types/time"
