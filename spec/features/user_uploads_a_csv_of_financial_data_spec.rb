require "rails_helper"

RSpec.feature "User uploads a csv of financial data" do
  scenario "user uploads via an upload button on the index page" do
    user = create(:user)

    visit financial_data_path(as: user)
    attach_file("file", Rails.root.join("test/sample.csv"))
    click_on "Save changes"

    expect(FinancialDatum.count).to eq 3
  end
end
