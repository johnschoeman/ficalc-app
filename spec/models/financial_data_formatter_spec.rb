require "rails_helper"

RSpec.describe FinancialDataFormatter do
  describe "#format" do
    it "takes a raw data hash and formats to the correct format" do
      raw_data = {
        month: 1, year: 2019, expenses: 10, income: 11, net_worth: 13,
      }
      user_id = 1
      formatter = FinancialDataFormatter.new
      expected_result = {
        month: :january,
        year: 2019,
        expenses: 10,
        income: 11,
        net_worth: 13,
        user_id: 1,
      }

      result = formatter.format(raw_data, user_id)

      expect(result).to eq(expected_result)
    end
  end
end
