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
