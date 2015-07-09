# encoding: utf-8

module Mixture
  module Validate
    # Checks that a value is present.
    class Presence < Base
      def validate(record, attribute, value)
        super
        error("Value is empty") if empty?
      end

      def empty?
        @value.nil? || (@value.respond_to?(:empty?) && @value.empty?)
      end
    end
  end
end
