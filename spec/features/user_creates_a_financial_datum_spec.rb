require "rails_helper"

RSpec.feature "User creates financial data entry" do
  scenario "user enters data via the index page" do
    user = create(:user)
    create(
      :financial_datum,
      user: user,
      year: 2018,
      month: "july",
      net_worth: 10_000,
    )
    create(
      :financial_datum,
      user: user,
      year: 2018,
      month: "august",
      net_worth: 20_000,
    )

    visit root_path(as: user)
    click_link "Financial Data"

    within("#financial-data-summary") do
      expect(page).to have_content "Financial Data Summary"
      expect(page).to have_content "20000"
    end

    click_on "New Financial Data Entry"
    select "september", from: "financial_datum_month"
    fill_in "Year", with: 2018
    fill_in "Income", with: 5000
    fill_in "Expenses", with: 3000
    fill_in "Net Worth", with: 100_000
    click_on "Create Financial datum"

    new_datum = FinancialDatum.last
    expect(page).to have_content "Financial Data Index"
    expect(page).to have_selector(:id, "financial-datum-row-#{new_datum.id}")
    expect(new_datum.income).to eq 5000

    within("#financial-data-summary") do
      expect(page).to have_content "100000"
    end
  end
end
