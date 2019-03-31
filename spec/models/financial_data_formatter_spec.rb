require "rails_helper"
require "csv"

RSpec.describe FinancialDataFormatter do
  describe "#build" do
    it "returns a hash of the data for a FinancialDatum" do
      month = 1
      year = 2019
      expenses = 12345
      income = 1000
      net_worth = 999999
      headers = ["month", "year", "expenses", "income", "net_worth"]
      fields = [month, year, expenses, income, net_worth]
      csv_row = CSV::Row.new(headers, fields)
      user_id = 1
      formatter = FinancialDataFormatter.new
      expected_result = {
        month: :february,
        year: year,
        expenses: expenses,
        income: income,
        net_worth: net_worth,
        user_id: user_id
      }.stringify_keys

      result = formatter.build(csv_row, user_id)

      expect(result).to eq(expected_result)
    end
  end
end
