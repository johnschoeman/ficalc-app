require 'rails_helper'
require 'clearance/rspec'

RSpec.feature "User creates financial data entry" do
  scenario "user enters data via the index page" do
    user = create(:user)
    create(:financial_datum, user: user)
    create(:financial_datum, user: user)

    visit root_path(as: user)
    click_link "Financial Data"
    expect_page_to_have_financial_data_for(user)

    click_on "New Financial Data Entry"
    select "january", from: "financial_datum_month"
    fill_in "Year", with: 2017
    fill_in "Income", with: 5000
    fill_in "Expenses", with: 3000
    fill_in "Net Worth", with: 100_000
    click_on "Create Financial datum"

    expect(page).to have_content "Financial Data Index"
    expect(page).to have_content "january 2017 $5000 $3000 $100000"
    expect(FinancialDatum.last.income).to eq 5000
  end
end

def expect_page_to_have_financial_data_for(user)
  user.financial_data.each do |datum|
    %i(month year income expenses net_worth).each do |attribute|
      expect(page).to have_content(datum.send(attribute).to_s)
    end
  end
end
