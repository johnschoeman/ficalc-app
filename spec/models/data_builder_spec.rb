require "rails_helper"
require "csv"

RSpec.describe DataBuilder do
  describe "#build" do
    it "raises if it is called" do
      builder = DataBuilder.new

      expect { builder.build }.to raise_error("Override this method")
    end
  end
end
