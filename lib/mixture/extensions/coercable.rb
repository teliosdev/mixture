# encoding: utf-8

module Mixture
  module Extensions
    # Extends the attribute definition to allow coercion.
    module Coercable
      # Performs the coercion for the attribute and the value.
      # It is used in a `:update` callback.
      #
      # @param attribute [Attribute] The attribute
      # @param value [Object] The new value.
      # @return [Object] The new new value.
      # @raise [CoercionError] If an error occurs while a coercion is
      #   running.
      def self.coerce_attribute(attribute, value)
        return value unless attribute.options[:type]
        attr_type = Type.infer(attribute.options[:type])
        value_type = Type.infer(value)

        block = Coerce.coerce(value_type, attr_type)

        begin
          block.call(value)
        rescue StandardError => e
          raise CoercionError, "#{e.class}: #{e.message}", e.backtrace
        end
      end

      # Called by Ruby when the module is included.
      #
      # @param base [Object]
      # @return [void]
      # @api private
      def self.included(base)
        base.attributes.callbacks[:update] << method(:coerce_attribute)
      end
    end
  end
end
