# encoding: utf-8

module Mixture
  module Validate
    class Base
      def initialize(options)
        @options = options
      end

      def validate(record, attribute, value)
        @record = record
        @attribute = attribute
        @value = value
      end

      def error(message)
        fail ValidationError, message
      end
    end
  end
end
