require 'rails_helper'

RSpec.feature 'Visitor inputs fi calc data' do
  scenario 'User inputs reasonable data and sees a result', js: true do
    visit root_path
    fill_in 'month-expenses', with: 1000
    fill_in 'month-income', with: 2000
    fill_in 'net-worth', with: 100_000
    fill_in 'change-in-monthly-expenses', with: 200
    fill_in 'change-in-monthly-income', with: 400
    fill_in 'change-in-net-worth', with: 10_000

    expect(page).to have_content('8 years and 2 months')
    expect(page).to have_content('4 months')
    expect(page).to have_content('Savings Rate: 50%')
    expect(page).to have_content('Monthly Portfolio Income: $333.33')
    expect(page).to have_content('Time to Depletion: 10 years and 7 months')
  end
end
