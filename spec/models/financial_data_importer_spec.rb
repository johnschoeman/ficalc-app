require "rails_helper"

RSpec.describe "FinancialDataImporter" do
  describe ".import" do
    context "given a csv file" do
      it "creates financial data for the rows" do
        require "csv"
        user = create(:user, id: 1)
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
        importer = FinancialDataImporter.new(filename, user.id)

        importer.import

        expect(FinancialDatum.count).to eq 3
      end
    end

    context "given a xlsx file" do
      it "creates financial data for the rows" do
        user = create(:user, id: 1)
        workbook = RubyXL::Workbook.new
        workbook.add_worksheet("Sheet 1")
        worksheet = workbook.worksheets.first
        worksheet.add_cell(0, 0, "month")
        worksheet.add_cell(0, 1, "year")
        worksheet.add_cell(0, 2, "income")
        worksheet.add_cell(0, 3, "expenses")
        worksheet.add_cell(0, 4, "net_worth")

        [1, 2019, 1000, 500, 10000].each_with_index do |el, idx|
          worksheet.add_cell(1, idx, el)
        end

        [2, 2019, 1000, 500, 10000].each_with_index do |el, idx|
          worksheet.add_cell(2, idx, el)
        end

        [3, 2019, 1000, 500, 10000].each_with_index do |el, idx|
          worksheet.add_cell(3, idx, el)
        end

        filename = "test.xlsx"
        allow(RubyXL::Parser).to receive(:parse).with(filename).and_return(
          workbook,
        )

        importer = FinancialDataImporter.new(filename, user.id)

        importer.import

        expect(FinancialDatum.count).to eq 3
      end
    end
  end
end
