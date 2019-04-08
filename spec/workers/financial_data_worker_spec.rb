require "rails_helper"

RSpec.describe FinancialDataImportWorker do
  describe "#perform" do
    it "fetches all the files from the ftp server" do
      file_path = "data/sample.csv"
      user_id = 1
      allow(FinancialDatum).to receive(:import)

      FinancialDataImportWorker.new.perform(file_path, user_id)

      expect(FinancialDatum).to have_received(:import).with(
        file_path,
        user_id,
      )
    end
  end
end
