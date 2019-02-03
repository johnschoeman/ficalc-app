require 'rails_helper'

RSpec.feature "User creates financial data entry" do
  scenario "user enters data via the index page" do
    user = create(:user)
    create(:financial_datum, user: user)
    create(:financial_datum, user: user)

    visit root_path(as: user)
    click_link "Financial Data"

    click_on "New Financial Data Entry"
    select "january", from: "financial_datum_month"
    fill_in "Year", with: 2017
    fill_in "Income", with: 5000
    fill_in "Expenses", with: 3000
    fill_in "Net Worth", with: 100_000
    click_on "Create Financial datum"

    new_datum = FinancialDatum.last
    expect(page).to have_content "Financial Data Index"
    expect(page).to have_selector(:id, "financial-datum-row-#{new_datum.id}")
    expect(new_datum.income).to eq 5000
  end
end
