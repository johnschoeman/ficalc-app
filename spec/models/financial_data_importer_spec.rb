require "rails_helper"

RSpec.describe "FinancialDataImporter" do
  describe ".import" do
    context "given a csv file" do
      it "imports the csv using the CsvImporter" do
        filename = "filename.csv"
        user_id = 1
        csv_importer_double = double("csv_importer")
        allow(csv_importer_double).to receive(:import)
        allow(CsvImporter).to receive(:new).with(filename, user_id).and_return(
          csv_importer_double,
        )
        importer = FinancialDataImporter.new(filename, user_id)

        importer.import

        expect(CsvImporter).to have_received(:new)
      end
    end

    context "given a xlsx file" do
      it "imports the xlsx using the XlsxImporter" do
        filename = "filename.xlsx"
        user_id = 1
        xlxs_importer_double = double("xlxs_importer")
        allow(xlxs_importer_double).to receive(:import)
        allow(XlsxImporter).to receive(:new).with(filename, user_id).and_return(
          xlxs_importer_double,
        )
        importer = FinancialDataImporter.new(filename, user_id)

        importer.import

        expect(XlsxImporter).to have_received(:new)
      end
    end

    context "given an unknown file type" do
      it "raises an error" do
        filename = "filename.foo"
        user_id = 1
        allow(XlsxImporter).to receive(:new)
        importer = FinancialDataImporter.new(filename, user_id)

        expect { importer.import }.to raise_error("Unknown file type")
      end
    end
  end
end
