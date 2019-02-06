require "rails_helper"

RSpec.describe "financial_data/_summary.html.erb" do
  context "the user has financial data" do
    it "renders the users financial summary" do
      user = build_stubbed(:user)
      create(:financial_datum, user: user)
      data_summary = FinancialDataSummary.new(user)
      allow(view).to receive(:current_user).and_return(user)

      render template: "financial_data/_summary.html.erb",
             locals: { data_summary: data_summary }

      expect(rendered).to have_text("Financial Data Summary")
      expect(rendered).to have_text("NetWorth")
      expect(rendered).to have_text("AveIncome")
      expect(rendered).to have_text("AveExpenses")
      expect(rendered).to have_text("%FI")
      expect(rendered).to have_text("TimeToFI")
      expect(rendered).to have_text("Date Of FI")
      expect(rendered).to have_content(data_summary.net_worth)
      expect(rendered).to have_content(data_summary.average_income)
      expect(rendered).to have_content(data_summary.average_expenses)
      expect(rendered).to have_content("%.2f" % data_summary.percent_fi)
      expect(rendered).to(
        have_content(
          "#{data_summary.time_to_fi / 12} years " \
          "#{data_summary.time_to_fi % 12} months",
        ),
      )
      expect(rendered).to have_content("years", "months")
    end
  end
end
