require "rails_helper"

RSpec.describe FinancialDatum, type: :model do
  describe "validations" do
    it { should belong_to :user }
    it { should validate_presence_of :month }
    it { should validate_presence_of :year }
    it { should validate_presence_of :income }
    it { should validate_presence_of :expenses }
    it { should validate_presence_of :net_worth }

    it do
      user = create(:user)
      create(:financial_datum, user: user)
      should validate_uniqueness_of(:user_id).scoped_to(:year, :month)
               .case_insensitive
               .with_message("You can only have one entry per month.")
    end

    it "only allows years within financial history" do
      user = create(:user)
      current_year = Time.zone.now.year
      valid_data = [user, "january", current_year, 1000, 500, 10_000]
      year_in_future = [user, "january", current_year + 1, 1000, 500, 10_000]
      year_in_past = [user, "january", 1969, 1000, 500, 10_000]

      valid_datum = FinancialDatum.build_for(*valid_data)
      invalid_datum_one = FinancialDatum.build_for(*year_in_future)
      invalid_datum_two = FinancialDatum.build_for(*year_in_past)

      expect(valid_datum).to be_valid
      expect(invalid_datum_one).not_to be_valid
      expect(invalid_datum_two).not_to be_valid
    end
  end

  describe ".get_data_for" do
    it "returns all the financial_data for a user ordered chronologically" do
      user = create(:user)
      datum_one =
        create(:financial_datum, user: user, year: 2018, month: "march")
      datum_two =
        create(:financial_datum, user: user, year: 2018, month: "july")
      datum_three =
        create(:financial_datum, user: user, year: 2017, month: "june")

      results = FinancialDatum.get_data_for(user)

      expect(results).to eq [datum_three, datum_one, datum_two]
    end
  end

  describe ".build_for" do
    it "builds a model instance for a provided user" do
      user = create(:user)

      datum = FinancialDatum.build_for(user)

      expect(datum).to be_valid
      expect(datum.user.email).to eq user.email
    end
  end

  describe "#percent_fi" do
    it "returns the percent fi for the datum" do
      datum = build_stubbed(:financial_datum, expenses: 500, net_worth: 75_000)
      expected_result = 0.5

      result = datum.percent_fi

      expect(result).to eq expected_result
    end

    context "the datum is over 100% fi" do
      it "returns 1.0" do
        datum = build_stubbed(:financial_datum, expenses: 1, net_worth: 100_000)
        expected_result = 1.0

        result = datum.percent_fi

        expect(result).to eq expected_result
      end
    end

    context "expenses is zero" do
      it "returns 1.0" do
        datum = build_stubbed(:financial_datum, expenses: 0)
        expected_result = 1.0

        result = datum.percent_fi

        expect(result).to eq expected_result
      end
    end
  end

  describe "#savings_rate" do
    it "returns the savings rate" do
      datum = build_stubbed(:financial_datum, expenses: 5, income: 10)
      expected_result = 0.5

      result = datum.savings_rate

      expect(result).to eq expected_result
    end

    context "income is 0" do
      it "returns 0.0" do
        datum = build_stubbed(:financial_datum, expenses: 5, income: 0)
        expected_result = 0.0

        result = datum.savings_rate

        expect(result).to eq expected_result
      end
    end
  end

  describe "#safe_withdraw_amount" do
    it "returns the amount of safewithdraw at 4%" do
      datum = build_stubbed(:financial_datum, net_worth: 300)
      expected_result = 1

      result = datum.safe_withdraw_amount

      expect(result).to eq expected_result
    end
  end

  describe "#net_worth_delta" do
    it "returns the delta in networth from last month" do
      user = create(:user)
      datum_one =
        create(:financial_datum, user: user, month: "january", year: 2018)
      datum_two =
        create(:financial_datum, user: user, month: "february", year: 2018)
      expected_result = datum_two.net_worth - datum_one.net_worth

      result = datum_two.net_worth_delta

      expect(result).to eq expected_result
    end

    context "there is no previous months datum" do
      it "returns nil" do
        datum = build_stubbed(:financial_datum)

        result = datum.net_worth_delta

        expect(result).to be_nil
      end
    end
  end

  describe "#average_expenses" do
    it "returns the 12month average of expenses up to that month" do
      user = create(:user)
      data = create_list(:financial_datum, 12, user: user, year: 2018)
      december_datum = data.select(&:december?).first
      expected_result =
        (data.reduce(0) { |acc, d| acc + d.expenses }) / data.length.to_f

      result = december_datum.average_expenses

      expect(result).to eq expected_result
    end
  end

  describe "#average_income" do
    it "returns the 12month average of income up to that month" do
      user = create(:user)
      data = create_list(:financial_datum, 12, user: user, year: 2018)
      december_datum = data.select(&:december?).first
      expected_result =
        (data.reduce(0) { |acc, d| acc + d.income }) / data.length.to_f

      result = december_datum.average_income

      expect(result).to eq expected_result
    end
  end
end
