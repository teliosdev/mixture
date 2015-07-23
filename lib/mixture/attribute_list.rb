# encoding: utf-8

require "set"
require "forwardable"

module Mixture
  # A list of attributes.  This is used instead of a hash in order to
  # add in the {#options} and {#callbacks}.
  class AttributeList
    extend Forwardable
    # If it looks like a duck...
    include Enumerable
    # If it quacks like a duck...
    include Comparable
    # Then it must be a duck.
    delegate [:fetch, :[], :[]=, :key?, :each, :<=>] => :@list

    # Returns a set of options used for the attributes.  This isn't
    # used at the moment.
    #
    # @return [Hash{Symbol => Object}]
    attr_reader :options

    # Returns a set of callbacks.  This is used for coercion, but may
    # be used for other things.
    #
    # @return [Hash{Symbol => Array<Proc>}]
    attr_reader :callbacks

    # Initializes the attribute list.
    def initialize
      @list = {}
      @options = {}
      @callbacks = Hash.new { |h, k| h[k] = Set.new }
    end

    # Creates a new attribute with the given name and options.
    #
    # @param name [Symbol] The name of the attribute.
    # @param options [Hash] The options for the attribute.
    # @return [Attribute]
    def create(name, options = {})
      @list[name] = Attribute.new(name, self, options)
    end
  end
end
