# encoding: utf-8

module Mixture
  module Validate
    # Checks that a value matches.
    class Match < Base
      register_as :match
      register_as :format
      # Performs the validation.
      #
      # @param (see Base#validate)
      # @return (see Base#validate)
      # @raise [ValidationError] If {#match?} returns false.
      def validate(record, attribute, value)
        super
        error("Value does not match") unless match?
      end

      private

      # Checks if the value matches the given matcher.  It uses the
      # `=~` operator.  If it fails (i.e. raises an error), it returns
      # false.
      #
      # @return [Boolean]
      def match?
        @value =~ @options
      rescue StandardError
        false
      end
    end
  end
end
