require 'rails_helper'

RSpec.describe FinancialDatum, type: :model do
  describe "validations" do
    it { should belong_to :user }
    it { should validate_presence_of :month }
    it { should validate_presence_of :year }
    it { should validate_presence_of :income }
    it { should validate_presence_of :expenses }
    it { should validate_presence_of :net_worth }
    it do
      should validate_uniqueness_of(:user_id).
        scoped_to(:year, :month).
        case_insensitive.
        with_message("You can only have one entry per month.")
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
end
