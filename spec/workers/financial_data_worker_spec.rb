require "rails_helper"

RSpec.describe FinancialDataImportWorker do
  describe "#perform" do
    it "fetches all the files from the ftp server" do
      file_path = "data/sample.csv"
      user_id = 1
      importer_double = double("importer")
      allow(importer_double).to receive(:import)
      allow(FinancialDataImporter).to receive(:new).and_return(importer_double)

      FinancialDataImportWorker.new.perform(file_path, user_id)

      expect(FinancialDataImporter).to have_received(:new).with(
        file_path,
        user_id,
      )
      expect(importer_double).to have_received(:import)
    end
  end
end
