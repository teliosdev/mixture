# encoding: utf-8

require "singleton"

module Mixture
  module Coerce
    # The base for coercion actions.  Each action defines the "from"
    # type, and the instance handles the "to".
    class Base
      include Singleton

      # @overload type()
      #   Returns the type this instance corresponds to.
      #
      #   @return [Mixture::Type]
      # @overload type(value)
      #   Sets the type this instance corresponds to.
      #
      #   @param value [Mixture::Type]
      #   @return [void]
      def self.type(value = Undefined)
        if value == Undefined
          @_type
        else
          @_type = value
        end
      end

      # The coercions that this class has.  It's a map of the type
      # to the method that performs that coercion.
      #
      # @return [Hash{Mixture::Type => Symbol}]
      def self.coercions
        @_coercions ||= {}
      end

      # This is a DSL for the class itself.  It essentially defines a
      # method to perform the coercion of the given type.
      #
      # @overload coerce_to(to) { }
      #   This is a DSL for the class itself.  It essentially defines
      #   a method to perform the coercion of the given type.
      #
      #   @param to [Mixture::Type] The type to coerce to.
      #   @yield [value] The block is called with the value to coerce
      #     when coercion needs to happen.  Note that the block is not
      #     used as the body of the method - the method returns the
      #     block.
      #   @yieldparam value [Object] The object to coerce.
      #   @yieldreturn [Object] The coerced value.
      #   @return [void]
      #
      # @overload coerce_to(to, value)
      #   This is a DSL for the class itself.  It essentially defines
      #   a method to perform the coercion of the given type.
      #
      #   @param to [Mixture::Type] The type to coerce to.
      #   @param value [Proc] The block that is called with the value
      #     for coercion.  This block is returned by the defined
      #     coercion method.
      #   @return [void]
      #
      def self.coerce_to(to, value = Undefined, &block)
        fail ArgumentError, "Expected Mixture::Type, got #{to.class}" unless
          to.is_a?(Mixture::Type)

        body = case
               when value != Undefined
                 value.to_proc
               when block_given?
                 block
               else
                 fail ArgumentError, "Expected a block"
               end

        coercions[to] = to.method_name
        define_method(to.method_name) { body }
      end

      # (see #to)
      def self.to(type)
        instance.to(type)
      end

      # Returns a block to perform the coercion to the given type.
      # If it cannot find a coercion, it raises {CoercionError}.
      #
      # @param type [Mixture::Type] The type to coerce to.
      # @raise [CoercionError] If it could not find the coercion.
      # @return [Proc{(Object) => Object}]
      def to(type)
        method_name = self.class.coercions.fetch(type) do
          fail CoercionError,
               "Undefined coercion of #{self.class.type} => #{type}"
        end

        public_send(method_name)
      end
    end
  end
end
