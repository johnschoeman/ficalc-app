require "rails_helper"

RSpec.describe FinancialDataValidator do
  describe "#valid?" do
    context "the data has all values as numbers" do
      it "returns true" do
        data = { month: "1", year: "2019", expenses: "$10", net_worth: "20", income: "3.0" }
        validator = FinancialDataValidator.new(data)

        result = validator.valid?

        expect(result).to eq true
      end
    end

    context "the data has any values not a nubmer" do
      it "returns false" do
        data = { month: "1", year: "2019", expenses: "asdf", net_worth: "20", income: "3.0" }
        validator = FinancialDataValidator.new(data)

        result = validator.valid?

        expect(result).to eq false
      end
    end
  end
end
