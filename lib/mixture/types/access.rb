# encoding: utf-8
# frozen_string_literal: true

module Mixture
  module Types
    # Used by certain types to create subtypes of those types.  This
    # is useful in collections and hashes, wherein the collection
    # members and hash keys/values all have types as well (and need
    # to be coerced to them).
    module Access
      # Creates a subtype with the given member types.  Any number of
      # subtypes may be used.  If a class hasn't been created with the
      # subtypes, it creates a new one.
      #
      # @see #create
      # @param subs [Object] The subtypes to use.
      # @return [Class] The new subtype.
      def [](*subs)
        inferred = infer_subs(subs)
        options[:types].fetch([self, inferred]) do
          create(inferred)
        end
      end

    private

      # Actually creates the subtype.  This should never be called
      # outside of {.[]}.  If `:noinfer` is set in the supertype's
      # options, it doesn't infer the type of each subtype; otherwise,
      # it does.
      #
      # @param inferred [Array<Object>] The subtypes.
      # @return [Class] The new subtype.
      def create(inferred)
        subtype = ::Class.new(self)
        name    = "#{inspect}[#{inferred.join(', ')}]"
        subtype.options.merge!(members: inferred, name: name)
        options[:types][[self, inferred]] = subtype
      end

      # Infers the subtypes, if the `:noinfer` option is not set.
      #
      # @param subs [Array<Object>] The subtypes to infer.
      # @return [Array<Object>] The inferred subtypes.
      def infer_subs(subs)
        if options[:noinfer]
          subs
        else
          subs.map { |sub| Types.infer(sub) }
        end
      end
    end
  end
end
