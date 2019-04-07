require "rails_helper"
require "csv"

RSpec.describe FinancialDataImporter do
  describe ".import" do
    it "takes a file and creates financial data from the data" do
      user = create(:user, id: 1)
      filename = Rails.root.join("spec/fixtures/sample_data.csv")
      importer = FinancialDataImporter.new

      importer.import(filename, user)

      expect(FinancialDatum.count).to eq 3
      march_datum = FinancialDatum.where(month: "march").take
      expect_datum_to_match(march_datum, "march", 2019, 3, 20, 300)
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
