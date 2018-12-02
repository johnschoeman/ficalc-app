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

    expect(page).to have_content "Financial Data Index"
    expect(page).to have_content "january 2017 $5000 $3000 $100000"
    expect(page).not_to have_content old_datum.to_s
    expect(FinancialDatum.last.income).to eq 5000
  end
end
