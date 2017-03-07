# encoding: utf-8
# frozen_string_literal: true

module Mixture
  # A model.
  #
  # @example
  #   class MyClass
  #     include Mixture::Model
  #     mixture_modules :attribute, :hash
  #   end
  module Model
    # The class methods for the module.
    module ClassMethods
      # Used to include certain extensions.
      #
      # @see Extensions.[]
      # @param mods [Symbol] The mod name to include.
      # @return [void]
      def mixture_modules(*mods)
        mods.each do |mod|
          include Extensions[mod]
        end
      end
    end

    # A method used internally by ruby.
    #
    # @api private
    def self.included(base)
      base.extend ClassMethods
      base.mixture_modules(:attribute, :coerce, :validate)
    end
  end
end
