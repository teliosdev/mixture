# encoding: utf-8

module Mixture
  module Validate
    # Checks that a value matches.
    class Match < Base
      def validate(record, attribute, value)
        super
        error("Value does not match") unless match?
      end

      def match?
        @value =~ @options
      end
    end
  end
end
