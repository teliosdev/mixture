# encoding: utf-8
# frozen_string_literal: true

module Mixture
  module Validate
    # Checks to make sure that the value isn't in the given set.  This
    # uses the `#includes?` method on the `@options`.
    class Exclusion < Base
      register_as :exclusion
      # Performs the validation.
      #
      # @param (see Base#validate)
      # @return (see Base#validate)
      def validate(record, attribute, value)
        super
        error("Value is in the given set") if
          @options[:in].include?(value)
      end
    end
  end
end
