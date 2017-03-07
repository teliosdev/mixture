# encoding: utf-8
# frozen_string_literal: true

module Mixture
  module Validate
    # Validates the length of an attribute.
    class Length < Base
      register_as :length
      # Validates the length of the value.  It first composes an
      # acceptable range, and then determines if the length is within
      # that acceptable range.  If either components error, the
      # validation fails.
      #
      # @param (see Base#validate)
      # @return [void]
      def validate(record, attribute, value)
        super
        error("Length is not acceptable") unless acceptable.cover?(length)
      end
      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity

      # Determines the acceptable range that the length ca nbe in.
      # This first turns the options into a hash via {#to_hash}, and
      # then checks the hash.
      #
      # @option options [Range] :in If this is provided, it is used
      #   as the acceptable range.
      # @option options [Numeric] :is If this is provided, it is used
      #   as an exact match.
      # @option options [Numeric] :maximum If this is provided without
      #   `:minimum`, it is set as the upper limit on the length (i.e.
      #   it is equivalent to `in: 0..maximum`).  If it is provided
      #   with `:minimum`, it is the upper limit (i.e. equivalent to
      #   `in: minimum..maximum`).
      # @option options [Numeric] :minimum If this is provided without
      #   `:maximum`, it is set as the lower limit on the length (i.e.
      #   equivalent to `in: minimum..Float::INFINITY`).  If it is
      #   provided with `:maximum`, it is the lower limit (i.e.
      #   equivalent to `in: minimum..maximum`).
      # @note If it is unable to find any of the options, or unable to
      #   turn the given value into a hash, it will raise a
      #   {ValidationError}.  This means validation will fail, even if
      #   the value may be valid.
      # @return [Range]
      # @see #to_hash
      def acceptable
        @_acceptable ||= begin
          options = to_hash(@options)

          if options.key?(:in)         then options[:in]
          elsif options.key?(:is)      then options[:is]..options[:is]
          elsif options.key?(:maximum) && options.key?(:minimum)
            options[:minimum]..options[:maximum]
          elsif options.key?(:maximum) then 0..options[:maximum]
          elsif options.key?(:minimum) then options[:minimum]..Float::INFINITY
          else
            error("Unable to determine acceptable range")
          end
        end
      end

      # rubocop:enable Metrics/AbcSize
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      # Turns any other recoginizable value into a hash that
      # {#acceptable} can use.  The mappings go as follows:
      #
      # - `Range`: turns into `{ in: value }`.
      # - `Numeric`: turns into `{ in: value..value }`
      # - `Array`: turns into `{ in: value[0]..value[1] }`
      # - `Hash`: turns into itself.
      #
      # Any other class/value causes an error.
      #
      # @param value [Object] The value to turn into a hash.
      # @return [Hash]
      # @raise [ValidationError] If it can't turn into a hash.
      def to_hash(value)
        case value
        when Range   then { in: value }
        when Numeric then { in: value..value }
        when Array   then { in: value[0]..value[1] }
        when Hash    then value
        else
          error("Unable to determine acceptable range")
        end
      end

      # Attempts to get the value of the length.  It tries the
      # `#size`, `#length`, and finally, `#count`; if it can't
      # find any of these, it raises an error.
      #
      # @return [Numeric] The length.
      # @raise [ValidationError] If it cannot determine the length of
      #   the value.
      def length
        if @value.respond_to?(:size) then @value.size
        elsif @value.respond_to?(:length)  then @value.length
        elsif @value.respond_to?(:count)   then @value.count
        else error("Value isn't countable")
        end
      end
    end
  end
end
