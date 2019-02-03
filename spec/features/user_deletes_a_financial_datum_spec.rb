require "rails_helper"

RSpec.feature "User deletes a financial datum" do
  scenario "user deletes a datum from the index page" do
    user = create(:user)
    datum = create(:financial_datum, user: user)

    visit financial_data_path(as: user)
    click_on "Delete"

    expect(page).not_to have_content datum.to_s
  end
end
