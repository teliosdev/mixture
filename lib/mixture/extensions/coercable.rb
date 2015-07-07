# encoding: utf-8

module Mixture
  module Extensions
    # Extends the attribute definition to allow coercion.
    module Coercable
      # Class methods.
      module ClassMethods
      end

      # Instance methods.
      module InstanceMethods
        private

        def coerce_attribute(attribute, value)
          return value unless attribute.options[:type]
        end
      end

      # Called by Ruby when the module is included.  This just
      # extends the base by the {ClassMethods} module and includes
      # into the base the {InstanceMethods} module.
      #
      # @param base [Object]
      # @return [void]
      # @api private
      def self.included(base)
        base.extend ClassMethods
        base.send :include, InstanceMethods
      end
    end
  end
end
