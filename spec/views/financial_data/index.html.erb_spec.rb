require "rails_helper"

RSpec.describe "financial_data/index.html.erb" do
  context "there is a list of financial data" do
    it "renders the data in a table" do
      user = build_stubbed(:user)
      datum_one = build_stubbed(:financial_datum, user: user)
      datum_two = build_stubbed(:financial_datum, user: user)
      datum_three =  build_stubbed(:financial_datum, user: user)
      financial_data = [datum_one, datum_two, datum_three]

      render template: "financial_data/index.html.erb",
             locals: { financial_data: financial_data }

      expect_rendered_to_have_table_row_for(financial_data)
    end

    it "renders the %FI, safe-withdraw-rate, and savings-rate" do
      datum = build_stubbed(:financial_datum)

      render template: "financial_data/index.html.erb",
             locals: { financial_data: [datum] }

      expect(rendered).to have_content("%FI")
      expect(rendered).to have_content("%.2f" % datum.percent_fi)
      expect(rendered).to have_content("SR")
      expect(rendered).to have_content("%.2f" % datum.savings_rate)
      expect(rendered).to have_content("4%SW")
      expect(rendered).to have_content(datum.safe_withdraw_amount)
    end

    it "renders the delta in net_worth from last month" do
      datum_one = create(:financial_datum, month: "january", year: 2018)
      datum_two = create(:financial_datum, month: "february", year: 2018)

      render template: "financial_data/index.html.erb",
             locals: { financial_data: [datum_one, datum_two] }

      expect(rendered).to have_content("deltaNW")
      expect(rendered).to have_content(datum_two.net_worth_delta)
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
