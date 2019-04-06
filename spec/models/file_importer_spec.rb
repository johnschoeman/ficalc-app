require "rails_helper"

RSpec.describe FileImporter do
  describe ".new" do
    it "initializes with a file path and user_id and a formatter" do
      filepath = "filepath"
      user_id = 1

      importer = FileImporter.new(filepath, user_id)

      expect(importer.formatter).to be_an_instance_of(FinancialDataFormatter)
    end
  end
end
