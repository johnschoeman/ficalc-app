require "rails_helper"

RSpec.describe "financial_data/_financial_datum_row.html.erb" do
  it "renders the %FI, safe-withdraw-rate, and savings-rate" do
    datum = create(:financial_datum)

    render template: "financial_data/_financial_datum_row.html.erb",
           locals: { datum: datum }

    expect(rendered).to have_content("%.2f" % datum.percent_fi)
    expect(rendered).to have_content("%.2f" % datum.savings_rate)
    expect(rendered).to have_content(datum.safe_withdraw_amount)
  end

  it "renders the delta in net_worth from last month" do
    _datum_one = create(:financial_datum, month: "january", year: 2018)
    datum_two = create(:financial_datum, month: "february", year: 2018)

    render template: "financial_data/_financial_datum_row.html.erb",
           locals: { datum: datum_two }

    expect(rendered).to have_content(datum_two.net_worth_delta)
  end

  it "renders the 12month average for expenses and income" do
    user = create(:user)
    data = create_list(:financial_datum, 12, user: user, year: 2018)
    december_datum = data.select(&:december?).first

    render template: "financial_data/_financial_datum_row.html.erb",
           locals: { datum: december_datum }

    expect(rendered).to have_content("%0.f" % december_datum.average_expenses)
    expect(rendered).to have_content("%0.f" % december_datum.average_income)
  end
end
