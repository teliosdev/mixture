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
        #
        # @param name [Symbol] The name of the attribute to validate.
        # @param options [Hash] The options for validation.  This is
        #   normally a key-value pair, where the key is the name of
        #   the validator, and the value is the options to pass to
        #   the validator.
        # @return [void]
        def validate(name, options = {})
          attributes.fetch(name).options[:validate] = options
        end
      end

      # The instance methods.
      module InstanceMethods
        # Validates the attributes on the record.  This will fill up
        # {#errors} with errors, if there are any.
        #
        # @return [Boolean]
        def valid?
          @errors = Hash.new { |h, k| h[k] = [] }
          self.class.attributes.each do |name, attribute|
            next unless attribute.options[:validate]
            Validate.validate(self, attribute, attribute(name))
          end
          !@errors.values.any?(&:any?)
        end

        # Opposite of valid.
        #
        # @see #valid?
        # @return [Boolean]
        def invalid?
          !valid?
        end

        # Returns a hash, mapping attributes to the errors that they
        # have.
        #
        # @return [Hash{Attribute => Array<ValidationError>}]
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
