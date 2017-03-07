# encoding: utf-8
# frozen_string_literal: true

module Mixture
  module Validate
    # Checks to make sure that the value is in the given set.  This
    # uses the `#includes?` method on the `@options`.
    class Inclusion < Base
      register_as :inclusion
      # Performs the validation.
      #
      # @param (see Base#validate)
      # @return (see Base#validate)
      def validate(record, attribute, value)
        super
        error("Value isn't in the given set") unless
          @options[:in].include?(value)
      end
    end
  end
end
