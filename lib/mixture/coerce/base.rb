# encoding: utf-8

require "singleton"

module Mixture
  module Coerce
    # The base for coercion actions.  Each action defines the "from"
    # type, and the instance handles the "to".
    class Base
      include Singleton
      # @!method type
      #   Returns the type this instance corresponds to.
      #
      #   @return [Mixture::Type]
      #
      # @!method type(value)
      #   Sets the type this instance corresponds to.
      #
      #   @param [Mixture::Type]
      #   @return [void]
      def self.type(value = Undefined)
        if value == Undefined
          @_type
        else
          @_type = value
        end
      end

      def self.coercions
        @_coercions ||= {}
      end

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

      def self.to(type)
        instance.to(type)
      end

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
