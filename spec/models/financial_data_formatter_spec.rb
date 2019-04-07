require "rails_helper"

RSpec.describe FinancialDataFormatter do
  describe "#format" do
    context "the data is in an integer format" do
      it "takes a raw data hash and formats to the correct format" do
        raw_data = {
          month: 3, year: 2019, expenses: 10, income: 11, net_worth: 13,
        }
        user_id = 1
        formatter = FinancialDataFormatter.new
        expected_result = {
          month: :april,
          year: 2019,
          expenses: 10.0,
          income: 11.0,
          net_worth: 13.0,
          user_id: 1,
        }

        result = formatter.format(raw_data, user_id)

        expect(result).to eq(expected_result)
      end
    end

    context "the integer data format is currency" do
      it "takes a raw data hash and formats it to the correct format" do
        raw_data = {
          month: 2,
          year: 2019,
          expenses: "$10",
          income: "$11",
          net_worth: "$1,300",
        }
        user_id = 1
        formatter = FinancialDataFormatter.new
        expected_result = {
          month: :march,
          year: 2019,
          expenses: 10,
          income: 11,
          net_worth: 1300,
          user_id: 1,
        }

        result = formatter.format(raw_data, user_id)

        expect(result).to eq(expected_result)
      end

      context "the file provides a date instead of a month and year" do
        context "the date is of format yyyy-mm-dd" do
          it "formats the data correctly" do
            raw_data = {
              date: "2019-01-01", expenses: 11, income: 12, net_worth: 1234,
            }
            user_id = 1
            formatter = FinancialDataFormatter.new
            expected_result = {
              month: :january,
              year: 2019,
              income: 12.0,
              expenses: 11.0,
              net_worth: 1234.0,
              user_id: 1,
            }

            result = formatter.format(raw_data, user_id)

            expect(result).to eq(expected_result)
          end
        end

        context "the date is of format yyyymmdd" do
          it "formats the date correctly" do
            raw_data = {
              date: "20190101", expenses: 11, income: 12, net_worth: 1234,
            }
            user_id = 1
            formatter = FinancialDataFormatter.new
            expected_result = {
              month: :january,
              year: 2019,
              income: 12.0,
              expenses: 11.0,
              net_worth: 1234.0,
              user_id: 1,
            }

            result = formatter.format(raw_data, user_id)

            expect(result).to eq(expected_result)
          end
        end
      end

      context "the month provided is a string" do
        it "formats the data correctly" do
          raw_data = {
            month: "1", year: 2019, expenses: 11, income: 12, net_worth: 1234,
          }
          user_id = 1
          formatter = FinancialDataFormatter.new
          expected_result = {
            month: :february,
            year: 2019,
            income: 12.0,
            expenses: 11.0,
            net_worth: 1234.0,
            user_id: 1,
          }

          result = formatter.format(raw_data, user_id)

          expect(result).to eq(expected_result)
        end
      end
    end
  end
end
