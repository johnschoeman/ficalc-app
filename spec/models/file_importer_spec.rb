require "rails_helper"

RSpec.describe FileImporter do
  describe ".new" do
    it "initializes with a file path and user_id and a builder" do
      file_path = "filepath"
      user_id = 1

      importer = FileImporter.new(file_path, user_id)

      expect(importer.file_path).to eq(file_path)
      expect(importer.user_id).to eq(user_id)
    end
  end
end
