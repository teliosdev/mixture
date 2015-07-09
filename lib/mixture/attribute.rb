# encoding: utf-8

module Mixture
  # An attribute for a mixture object.
  class Attribute
    # The name of the attribute.
    #
    # @return [Symbol]
    attr_reader :name

    # The options for the attribute.  This is mainly used for coercion
    # and validation.
    #
    # @return [Hash]
    attr_reader :options

    # Initialize the attribute.
    #
    # @param name [Symbol] The name of the attribute.
    # @param list [AttributeList] The attribute list this attribute is
    #   a part of.
    # @param options [Hash] The optiosn for the attribute.
    def initialize(name, list, options = {})
      @name = name
      @list = list
      @options = options
    end

    # Update the attribute with the given value.  It runs the value
    # through the callbacks, and returns a new value given by the
    # callbacks.
    #
    # @param value [Object] The new value.
    # @return [Object] The new new value.
    def update(value)
      @list.callbacks[:update].inject(value) { |a, e| e.call(self, a) }
    end

    # The instance variable for this attribute.
    #
    # @example
    #   attribute.ivar # => :@name
    # @return [Symbol]
    def ivar
      @_ivar ||= :"@#{@name}"
    end

    # The getter method for this attribute.
    #
    # @example
    #   attribute.getter # => :name
    # @return [Symbol]
    def getter
      @name
    end

    # The setter method for this attribute.
    #
    # @example
    #   attribute.setter # :name=
    # @return [Symbol]
    def setter
      @_setter ||= :"#{@name}="
    end
  end
end
