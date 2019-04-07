require "rails_helper"

RSpec.describe XlsxBuilder do
  describe "#build" do
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
      builder = XlsxBuilder.new
      expected_result = {
        month: :february,
        year: year,
        expenses: expenses,
        income: income,
        net_worth: net_worth,
        user_id: user_id,
      }

      result = builder.build(xlsx_row, user_id)

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
