require "rails_helper"

RSpec.feature "User navigates the app" do
  scenario "user visits about, contact, then root" do
    visit root_path
    expect(page).to have_content("Time To FI Calculator")
    within(".navbar") do
      click_on("About")
    end
    expect(page).to have_content("What Is FI?")
    click_on("Contact")
    expect(page).to have_content("Do you have questions or comments? I'd love to hear from you! ")
    click_on("TimeToFICalc")
    expect(page).to have_content("Time To FI Calculator")
  end
end
