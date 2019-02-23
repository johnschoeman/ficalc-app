require "rails_helper"

RSpec.describe "financial_data/_table.html.erb" do
  it "renders the data in a table" do
    user = create(:user)
    datum_one = create(:financial_datum, user: user)
    datum_two = create(:financial_datum, user: user)
    datum_three = create(:financial_datum, user: user)
    financial_data = [datum_one, datum_two, datum_three]
    data_summary = FinancialDataSummary.new(user)
    allow(view).to receive(:current_user).and_return(user)

    render template: "financial_data/index.html.erb",
           locals: {
             financial_data: financial_data, data_summary: data_summary,
           }

    expect_rendered_to_have_table_row_for(financial_data)
  end

  it "renders a table of financial data" do
    user = create(:user)
    data = create_list(:financial_datum, 12, user: user, year: 2018)
    data_summary = FinancialDataSummary.new(user)
    allow(view).to receive(:current_user).and_return(user)

    render template: "financial_data/index.html.erb",
           locals: { financial_data: data, data_summary: data_summary }

    expect(rendered).to have_content("Month")
    expect(rendered).to have_content("Year")
    expect(rendered).to have_content("Income")
    expect(rendered).to have_content("Expenses")
    expect(rendered).to have_content("NetWorth")
    expect(rendered).to have_content("%FI")
    expect(rendered).to have_content("deltaNW")
    expect(rendered).to have_content("12MonthAveExpenses")
    expect(rendered).to have_content("12MonthAveIncome")
  end
end
