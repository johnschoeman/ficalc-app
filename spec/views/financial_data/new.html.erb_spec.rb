require "rails_helper"

RSpec.describe "financial_data/new.html.erb" do
  context "the user tried to submit an invalid datum" do
    it "renders errors" do
      error_message = Faker::Lorem.sentence
      datum = build_stubbed(:financial_datum)

      render template: "financial_data/new.html.erb",
             locals: { financial_datum: datum, errors: [error_message] }

      expect(rendered).to have_content(error_message)
    end
  end
end
