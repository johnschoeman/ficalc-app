require "rails_helper"

RSpec.describe FinancialDataSummary do
  describe "validations" do
    it "accepts as user as an initial value" do
      user = build_stubbed(:user)

      financial_summary = FinancialDataSummary.new(user)

      expect(financial_summary).to be_valid
    end
  end

  describe "#net_worth" do
    it "returns the most recent net worth of the user" do
      user = create(:user)
      net_worth = Faker::Number.number(5).to_i
      other_net_worth = net_worth - 1
      create(
        :financial_datum,
        user: user, year: 2018, month: "january", net_worth: net_worth,
      )
      create(
        :financial_datum,
        user: user, year: 2017, month: "february", net_worth: other_net_worth,
      )
      financial_summary = FinancialDataSummary.new(user)

      result = financial_summary.net_worth

      expect(result).to eq net_worth
    end
  end

  describe "#average_income" do
    it "returns the income averaged over the last 12 months" do
      user = create(:user)
      data = create_list(:financial_datum, 12, user: user, year: 2018)
      financial_summary = FinancialDataSummary.new(user)
      expected_result =
        (data.reduce(0) { |acc, d| acc + d.income }) / data.length

      result = financial_summary.average_income

      expect(result).to eq expected_result
    end
  end

  describe "#average_expenses" do
    it "returns the expenses averaged over the last 12 months" do
      user = create(:user)
      data = create_list(:financial_datum, 12, user: user, year: 2018)
      financial_summary = FinancialDataSummary.new(user)
      expected_result =
        (data.reduce(0) { |acc, d| acc + d.expenses }) / data.length

      result = financial_summary.average_expenses

      expect(result).to eq expected_result
    end
  end

  describe "#percent_fi" do
    it "it returns the percent fi based off net worth and average expenses" do
      user = create(:user)
      create(
        :financial_datum,
        user: user,
        year: 2017,
        month: "january",
        expenses: 250,
        net_worth: 50_000,
      )
      create(
        :financial_datum,
        user: user,
        year: 2017,
        month: "february",
        expenses: 750,
        net_worth: 75_000,
      )
      expected_result = 0.5
      financial_summary = FinancialDataSummary.new(user)

      result = financial_summary.percent_fi

      expect(result).to eq expected_result
    end
  end
end
