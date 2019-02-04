require "rails_helper"

RSpec.describe "financial_data/index.html.erb" do
  context "there is a list of financial data" do
    it "renders the summary and data table" do
      user = build_stubbed(:user)
      data = [create(:financial_datum, user: user)]
      summary = FinancialDataSummary.new(user)

      allow(view).to receive(:current_user).and_return(user)

      render template: "financial_data/index.html.erb",
             locals: { financial_data: data, data_summary: summary }

      expect(rendered).to have_text("Data Summary")
      expect(rendered).to have_text("Financial Data Index")
    end
  end

  context "the user has no data" do
    it "renders a welcome message" do
      user = build_stubbed(:user)
      allow(view).to receive(:current_user).and_return(user)

      render template: "financial_data/index.html.erb"

      expect(rendered).to have_text("Welcome to the FI Index Page!")
    end
  end
end

def expect_rendered_to_have_table_row_for(financial_data)
  financial_data.each do |datum|
    expect(rendered).to have_selector(:id, "financial-datum-row-#{datum.id}")
    %i(month year income expenses net_worth).each do |attribute|
      expect(rendered).to have_content(datum.send(attribute.to_sym).to_s)
    end
  end
end
