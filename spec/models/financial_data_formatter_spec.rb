require "rails_helper"

RSpec.describe FinancialDataFormatter do
  describe "#format" do
    context "the data is in an integer format" do
      it "takes a raw data hash and formats to the correct format" do
        raw_data = {
          month: 3, year: 2019, expenses: 10, income: 11, net_worth: 13,
        }
        user_id = 1
        formatter = FinancialDataFormatter.new
        expected_result = {
          month: :april,
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

    context "the integer data format is currency" do
      it "takes a raw data hash and formats it to the correct format" do
        raw_data = {
          month: 2,
          year: 2019,
          expenses: "$10",
          income: "$11",
          net_worth: "$1,300",
        }
        user_id = 1
        formatter = FinancialDataFormatter.new
        expected_result = {
          month: :march,
          year: 2019,
          expenses: 10,
          income: 11,
          net_worth: 1300,
          user_id: 1,
        }

        result = formatter.format(raw_data, user_id)

        expect(result).to eq(expected_result)
      end
    end
  end
end
