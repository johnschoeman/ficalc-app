require "rails_helper"

RSpec.describe "FiCalculator" do
  describe ".time_to_fi" do
    context "it is possible to reach fi" do
      it "returns the time to fi in months" do
        expenses_one = 100
        income_one = 10000
        net_worth_one = 0

        expenses_two = 1000
        income_two = 10000
        net_worth_two = 0

        expenses_three = 2000
        income_three = 2100
        net_worth_three = 100000

        result_one =
          FiCalculator.new(
            net_worth: net_worth_one,
            expenses: expenses_one,
            income: income_one,
          )
            .time_to_fi

        result_two =
          FiCalculator.new(
            net_worth: net_worth_two,
            expenses: expenses_two,
            income: income_two,
          )
            .time_to_fi

        result_three =
          FiCalculator.new(
            net_worth: net_worth_three,
            expenses: expenses_three,
            income: income_three,
          )
            .time_to_fi

        expect(result_one).to eq 4
        expect(result_two).to eq 31
        expect(result_three).to eq 255
      end
    end

    context "fi has already been reached" do
      it "returns 0" do
        expenses = 100
        income = 0
        net_worth = 100000

        result =
          FiCalculator.new(
            net_worth: net_worth, expenses: expenses, income: income,
          )
            .time_to_fi

        expect(result).to eq 0
      end
    end

    context "fi can never be reached" do
      it "returns 1200" do
        expenses = 1000
        income = 100
        net_worth = 0

        result =
          FiCalculator.new(
            net_worth: net_worth, expenses: expenses, income: income,
          )
            .time_to_fi

        expect(result).to eq 1200
      end
    end
  end
end
