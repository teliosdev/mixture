# encoding: utf-8
# frozen_string_literal: true

module Mixture
  module Validate
    # A base for validations.  All validators should inherit this
    # class.
    #
    # @abstract
    class Base
      # Registers this validator as the given name.
      #
      # @see Validate.register
      # @param name [Symbol] The name of the validator.
      # @return [void]
      def self.register_as(name)
        Validate.register(name, self)
      end

      # Initialize the validator.
      #
      # @param options [Hash] The options for the validator.
      def initialize(options)
        @options = options
      end

      # Performs the validation.
      #
      # @param record [Mixture::Model] The model that has the
      #   attribute.  At least, it should respond to `#errors`.
      # @param attribute [Attribute] The attribute to validate.
      # @param value [Object] The value of the attribute.
      # @return [void]
      # @abstract
      def validate(record, attribute, value)
        @record = record
        @attribute = attribute
        @value = value
      end

    private

      # Raises an error with the given a message.
      #
      # @param message [String] The message to raise.
      # @raise [ValidationError]
      def error(message)
        fail ValidationError, message
      end
    end
  end
end
