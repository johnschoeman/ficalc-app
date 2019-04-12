require "rails_helper"
require "csv"

RSpec.describe "CsvImporter" do
  describe ".import" do
    it "creates financial data for the rows" do
      user = create(:user)
      file =
        CSV.generate do |csv|
          csv << %w[month year income expenses net_worth]
          csv << %w[3 2019 1000 500 10000]
          csv << %w[4 2019 1000 500 10000]
          csv << %w[5 2019 1000 500 10000]
        end
      filename = "test.csv"
      allow(File).to receive(:open).with(
        filename,
        "r",
        { headers: true, universal_newline: false },
      )
        .and_return(file)
      importer = CsvImporter.new(filename, user.id)

      importer.import

      expect(FinancialDatum.count).to eq 3
    end

    context "the csv has currency formatted data" do
      it "creates the data for the rows" do
        user = create(:user)
        file =
          CSV.generate do |csv|
            csv << %w[month year income expenses net_worth]
            csv << %w[3 2019 $1,000 $500 $1,0000]
            csv << %w[4 2019 $1,000 $500 $1,0000]
            csv << %w[5 2019 $1,000 $500 $1,0000]
          end
        filename = "test.csv"
        allow(File).to receive(:open).with(
          filename,
          "r",
          { headers: true, universal_newline: false },
        )
          .and_return(file)
        importer = CsvImporter.new(filename, user.id)

        importer.import

        expect(FinancialDatum.count).to eq 3
        last_datum = FinancialDatum.last
        expect(last_datum.income).to eq(1000)
        expect(last_datum.expenses).to eq(500)
        expect(last_datum.net_worth).to eq(10000)
      end
    end

    context "the csv has non-numerical data" do
      it "does not create the data for those rows" do
        user = create(:user)
        file =
          CSV.generate do |csv|
            csv << %w[month year income expenses net_worth]
            csv << %w[3 2019 $1000 $500 $10000]
            csv << %w[4 2019 $1,000 $500 $asdf]
            csv << %w[5 2019 $1,000 $asdf $1,0000]
          end
        filename = "test.csv"
        allow(File).to receive(:open).with(
          filename,
          "r",
          { headers: true, universal_newline: false },
        )
          .and_return(file)
        importer = CsvImporter.new(filename, user.id)

        importer.import

        expect(FinancialDatum.count).to eq 1
        last_datum = FinancialDatum.last
        expect(last_datum.income).to eq(1000)
        expect(last_datum.expenses).to eq(500)
        expect(last_datum.net_worth).to eq(10000)
      end
    end
  end
end
