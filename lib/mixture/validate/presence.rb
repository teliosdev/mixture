# encoding: utf-8
# frozen_string_literal: true

module Mixture
  module Validate
    # Checks that a value is present.
    class Presence < Base
      register_as :presence
      # Performs the validation.
      #
      # @param (see Base#validate)
      # @return (see Base#validate)
      # @raise [ValidationError] If {#empty?} returns true.
      def validate(record, attribute, value)
        super
        error("Value is empty") if empty?
      end

    private

      # Determins if the given value is empty.  If it's not nil,
      # and it responds to `empty?`, it returns the value of `empty?`;
      # otherwise, it returns the value of `nil?`.
      #
      # @return [Boolean]
      def empty?
        @value.nil? || (@value.respond_to?(:empty?) && @value.empty?)
      end
    end
  end
end
