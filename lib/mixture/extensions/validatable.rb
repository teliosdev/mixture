# encoding: utf-8

module Mixture
  module Extensions
    # Allows attributes to be validated based on a predefined set of
    # principles.
    module Validatable
      # The class methods.
      module ClassMethods
        # Creates a new validation for the given attribute.  The
        # attribute _must_ be defined before this call, otherwise it
        # _will_ error.
        def validate(name, options = {})
          attributes.fetch(name).options[:validate] = options
        end
      end

      # The instance methods.
      module InstanceMethods
        # Validates the attributes on the record.
        def valid?
          @errors = Hash.new { |h, k| h[k] = [] }
          self.class.attributes.each do |name, attribute|
            next unless attribute.options[:validate]
            Validate.validate(self, attribute, attribute(name))
          end
          !@errors.values.any?(&:any?)
        end

        def invalid?
          !valid?
        end

        def errors
          @errors ||= Hash.new { |h, k| h[k] = [] }
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
