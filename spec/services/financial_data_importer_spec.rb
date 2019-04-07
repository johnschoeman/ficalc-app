require "rails_helper"
require "csv"

RSpec.describe FinancialDataImporter do
  describe ".import" do
    context "the file is of format a" do
      it "takes the file and creates a financial_datum for each row" do
        users = create_list(:user, 2)
        csv_filename = Rails.root.join("spec/fixtures/sample_data_format_a.csv")
        xlsx_filename =
          Rails.root.join("spec/fixtures/sample_data_format_a.xlsx")
        importer = FinancialDataImporter.new

        importer.import(csv_filename, users[0].id)
        importer.import(xlsx_filename, users[1].id)

        expect(FinancialDatum.count).to eq 6
        datum_one =
          FinancialDatum.where(month: "march", user_id: users[0].id).take
        datum_two =
          FinancialDatum.where(month: "march", user_id: users[1].id).take
        expect_datum_to_match(datum_one, "march", 2019, 3, 30, 300)
        expect_datum_to_match(datum_two, "march", 2019, 3, 30, 300)
      end
    end

    context "the file is of format b" do
      it "takes the file and creates a financial_datum for each row" do
        users = create_list(:user, 2)
        csv_filename = Rails.root.join("spec/fixtures/sample_data_format_b.csv")
        xlsx_filename =
          Rails.root.join("spec/fixtures/sample_data_format_b.xlsx")
        importer = FinancialDataImporter.new

        importer.import(csv_filename, users[0].id)
        importer.import(xlsx_filename, users[1].id)

        expect(FinancialDatum.count).to eq 6
        datum_one =
          FinancialDatum.where(month: "march", user_id: users[0].id).take
        datum_two =
          FinancialDatum.where(month: "march", user_id: users[1].id).take
        expect_datum_to_match(datum_one, "march", 2019, 3, 30, 300)
        expect_datum_to_match(datum_two, "march", 2019, 3, 30, 300)
      end
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
