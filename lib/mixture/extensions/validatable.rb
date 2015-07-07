# encoding: utf-8

module Mixture
  module Extensions
    # Allows attributes to be validated based on a predefined set of
    # principles.
    module Validatable
      # The class methods.
      module ClassMethods
      end

      # The instance methods.
      module InstanceMethods
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
