require "rails_helper"
require "csv"

RSpec.describe FinancialDataFormatter do
  describe "#build_csv" do
    it "returns a hash of the data for a FinancialDatum" do
      month = 1
      year = 2019
      expenses = 12345
      income = 1000
      net_worth = 999999
      headers = %w[month year expenses income net_worth]
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
        user_id: user_id,
      }
        .stringify_keys

      result = formatter.build_csv(csv_row, user_id)

      expect(result).to eq(expected_result)
    end
  end

  describe "#build_xlsx" do
    it "returns a hash of the data for a FinancialDatum" do
      month = 1
      year = 2019
      expenses = 12345
      income = 1000
      net_worth = 999999
      cell_one = build_cell(1, 0, month)
      cell_two = build_cell(1, 1, year)
      cell_three = build_cell(1, 2, income)
      cell_four = build_cell(1, 3, expenses)
      cell_five = build_cell(1, 4, net_worth)
      xlsx_row = RubyXL::Row.new
      xlsx_row.cells = [cell_one, cell_two, cell_three, cell_four, cell_five]
      user_id = 1
      formatter = FinancialDataFormatter.new
      expected_result = {
        month: :february,
        year: year,
        expenses: expenses,
        income: income,
        net_worth: net_worth,
        user_id: user_id,
      }
        .stringify_keys

      result = formatter.build_xlsx(xlsx_row, user_id)

      expect(result).to eq(expected_result)
    end
  end

  def build_cell(row, column, value)
    cell = RubyXL::Cell.new
    cell.row = row
    cell.column = column
    allow(cell).to receive(:value).and_return(value)
    cell
  end
end
