# encoding: utf-8
# frozen_string_literal: true

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
    delegate [:<=>, :[]=, :to_h] => :@list

    # @!method fetch(key, value = Undefined, &block)
    #   Fetches the given key from the attribute list.  If the current attribute
    #   list does not have the key, it passes it up to the parent, if there is
    #   one.  If there is no parent, it behaves as normal.
    #
    #   @param key [::Symbol]
    #   @param value [::Object]
    #   @return [Attribute]
    # @!method [](key)
    #   Looks up the given key.  If the current attribute list does not have the
    #   key, it passes it up to the parent, if there is one.  Otherwise, it
    #   returns the default value for the list (`nil`).
    #
    #   @param key [::Symbol]
    #   @return [Attribute]
    # @!method key?(key)
    #   Returns if the attribute exists.  If it doesn't exist on this list,
    #   it passes it up to the parent.
    #
    #   @param key [::Symbol]
    #   @return [::Boolean]
    # @!method each(&block)
    #   Iterates over the attribute list.  If there is a parent, the current
    #   attribute list is merged into the parent, then iterated over; otherwise,
    #   it iterates over the current.
    #
    #   @return [void]
    delegate [:fetch, :[], :key?, :keys, :values, :each, :has_key?] => :with_parent

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

    # The parent of this attribute list.  This is "merged" into this attribute
    # list.  This shouldn't be set since it is automatically assumed; however,
    # sometimes it can be assumed wrong.
    #
    # @return [AttributeList, nil]
    attr_accessor :parent

    # Initializes the attribute list.
    #
    # @param parent [AttributeList] The parent {AttributeList}.  This is used
    #   primarily for inheritance.
    def initialize(parent = nil)
      @list = {}
      @options = {}
      @parent = parent
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

  protected

    def with_parent
      @parent ? @list.merge(@parent.with_parent) : @list
    end
  end
end
