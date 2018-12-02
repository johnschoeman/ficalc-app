if Rails.env.development? || Rails.env.test?
  require "factory_bot"

  namespace :dev do
    desc "Sample data for local development environment"
    task prime: "db:setup" do
      include FactoryBot::Syntax::Methods
      FactoryBot.find_definitions

      user = create(:user, email: "test@test.com", password: "password")
      FinancialDatum::MONTHS.each do |month|
        create(:financial_datum, user: user, month: month, year: 2018)
      end
    end
  end
end
