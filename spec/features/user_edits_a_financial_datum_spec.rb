require "rails_helper"

RSpec.feature "User edits a financial datum" do
  scenario "user edits a datum from the index page" do
    user = create(:user)
    old_datum = create(:financial_datum, user: user)

    visit financial_data_path(as: user)
    click_on "Edit"

    expect(page).to have_content "Edit financial datum: #{old_datum.id}"
    select "january", from: "financial_datum_month"
    fill_in "Year", with: 2017
    fill_in "Income", with: 5000
    fill_in "Expenses", with: 3000
    fill_in "Net Worth", with: 100_000
    click_on "Update Financial datum"

    edited_datum = FinancialDatum.last
    expect(page).to have_content "Financial Data Index"
    expect(page).to have_selector(:id, "financial-datum-row-#{edited_datum.id}")
    %w(2017 5000 3000 100000).each do |text|
      expect(page).to have_content(text)
    end
    expect(edited_datum.income).to eq 5000
  end
end
