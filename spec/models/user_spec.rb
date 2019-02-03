require "rails_helper"

RSpec.describe User do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_length_of(:password).is_at_least(6).on(:create) }
  it { should have_many :financial_data }

  describe "#has_financial_data?" do
    context "the user has financial data" do
      it "returns true" do
        user = build_stubbed(:user)
        create(:financial_datum, user: user)

        result = user.has_financial_data?

        expect(result).to be true
      end
    end

    context "the user does not have financial data" do
      it "returns false" do
        user = build_stubbed(:user)

        result = user.has_financial_data?

        expect(result).to be false
      end
    end
  end
end
