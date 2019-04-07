require "rails_helper"
require "csv"

RSpec.describe FinancialDataImporter do
  describe ".import" do
    it "takes a file and creates financial data from the data" do
      user_one = create(:user)
      user_two = create(:user)
      csv_filename = Rails.root.join("spec/fixtures/sample_data.csv")
      xlsx_filename = Rails.root.join("spec/fixtures/sample_data.xlsx")
      importer = FinancialDataImporter.new

      importer.import(xlsx_filename, user_two.id)

      importer.import(csv_filename, user_one.id)

      expect(FinancialDatum.count).to eq 6
      user_one_march_datum =
        FinancialDatum.where(month: "march", user_id: user_one.id).take
      user_two_march_datum =
        FinancialDatum.where(month: "march", user_id: user_two.id).take
      expect_datum_to_match(user_one_march_datum, "march", 2019, 3, 30, 300)
      expect_datum_to_match(user_two_march_datum, "march", 2019, 3, 30, 300)
    end
  end

  def expect_datum_to_match(datum, month, year, expenses, income, net_worth)
    expect(datum.month).to eq(month)
    expect(datum.year).to eq(year)
    expect(datum.expenses).to eq(expenses)
    expect(datum.income).to eq(income)
    expect(datum.net_worth).to eq(net_worth)
  end
end
