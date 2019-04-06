require "rails_helper"

RSpec.describe "CsvImporter" do
  describe ".import" do
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
      importer = CsvImporter.new(filename, user.id)

      importer.import

      expect(FinancialDatum.count).to eq 3
    end
  end
end
