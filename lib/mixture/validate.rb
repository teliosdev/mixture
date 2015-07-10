# encoding: utf-8

module Mixture
  # Handles validation of attributes.  You can register validators
  # with this module, and they will be used to validate attributes.
  # Check out {Validate::Base} for the expected interface.
  module Validate
    # Registers a validator.  This lets Mixture know about the
    # validators that can occur.
    #
    # @param name [Symbol] The name of the validator.  This is used in
    #   the {Extensions::Validatable::ClassMethods#validate} call as
    #   a key.
    # @param validator [Validate::Base] The validator to use.
    # @return [void]
    def self.register(name, validator)
      validations[name] = validator
    end

    # The validators that are currently registered.  This returns a
    # key-value hash of validations.
    #
    # @return [Hash{Symbol => Validate::Base}]
    def self.validations
      @_validations ||= {}
    end

    require "mixture/validate/base"
    require "mixture/validate/exclusion"
    require "mixture/validate/inclusion"
    require "mixture/validate/length"
    require "mixture/validate/match"
    require "mixture/validate/presence"

    # Performs a validation on the attribute.  It loops through the
    # validation requirements on the attribute, and runs each
    # validation with {.validate_with}.
    #
    # @param record [Mixture::Model] A class that has included
    #   {Mixture::Model} or {Mixture::Extensions::Validatable}.
    # @param attribute [Mixture::Attribute] The attribute to validate.
    # @param value [Object] The new value of the attribute.
    # @return [void]
    def self.validate(record, attribute, value)
      return unless attribute.options[:validate]
      attribute.options[:validate].each do |k, v|
        validator = validations.fetch(k).new(v)
        validate_with(validator, record, attribute, value)
      end
    end

    # Validates a (record, attribute, value) triplet with the given
    # validator.  It calls `#validate` on the validator with the
    # three as arguments, and rescues any validation errors thrown
    # (and places them in `record.errors`).
    #
    # @param validator [Validator::Base, #validate]
    #   The validator to validate with.
    # @param record [Mixture::Model]
    # @param attribute [Mixture::Attribute] The attribute to validate.
    # @param value [Object] The new value.
    # @return [void]
    def self.validate_with(validator, record, attribute, value)
      validator.validate(record, attribute, value)

    rescue ValidationError => e
      record.errors[attribute] << e
    end
  end
end
