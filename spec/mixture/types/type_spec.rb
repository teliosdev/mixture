# encoding: utf-8
# frozen_string_literal: true

RSpec.describe Mixture::Types::Type do
  describe ".new" do
    it "is private" do
      expect { Mixture::Types::Type.new }.to raise_error(NoMethodError)
    end
  end
end
