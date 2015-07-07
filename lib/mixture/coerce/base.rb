# encoding: utf-8

module Mixture
  module Coerce
    # The base for coercion actions.  Each action defines the "from"
    # type, and the instance handles the "to".
    class Base
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

      def self.coerce_to(to, &block)
        fail ArgumentError, "Expected Mixture::Type, got #{to.class}" unless
          to.is_a?(Mixture::Type)

        flat_to = to.name.gsub(/::([A-Z])/, "_\\1").gsub(/([A-Z])/, "_\\1")
        method_name = :"to_#{flat_to}"
        coercions[to] = method_name
        define_method(method_name) { block }
      end
    end
  end
end
