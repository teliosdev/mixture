# encoding: utf-8

require "forwardable"

module Mixture
  # A list of attributes.
  class AttributeList
    extend Forwardable
    # If it looks like a duck...
    include Enumerable
    # If it quacks like a duck...
    include Comparable
    # Then it must be a duck.
    delegate [:fetch, :[], :[]=, :key?, :each, :<=>] => :@list

    attr_reader :options
    attr_reader :callbacks

    def initialize
      @list = {}
      @options = {}
      @callbacks = Hash.new { |h, k| h[k] = [] }
    end

    def create(name, options = {})
      @list[name] = Attribute.new(name, self, options)
    end
  end
end
