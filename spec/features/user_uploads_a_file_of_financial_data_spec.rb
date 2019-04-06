require "rails_helper"

RSpec.feature "User uploads a file of financial data" do
  context "and the file is a csv" do
    scenario "the user uploads via an upload button on the index page" do
      user = create(:user)

      visit financial_data_path(as: user)
      attach_file("file", Rails.root.join("spec/fixtures/fi_data.csv"))
      click_on "Save changes"

      expect(FinancialDatum.count).to eq 3
    end
  end

  context "and the file is a xslx" do
    scenario "the user uploads via an upload button on the index page" do
      user = create(:user)

      visit financial_data_path(as: user)
      attach_file("file", Rails.root.join("spec/fixtures/fi_data.xlsx"))
      click_on "Save changes"

      expect(FinancialDatum.count).to eq 3
    end
  end
end
