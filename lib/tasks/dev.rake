if Rails.env.development? || Rails.env.test?
  require "factory_bot"

  namespace :dev do
    desc "Sample data for local development environment"
    task prime: "db:setup" do
      include FactoryBot::Syntax::Methods
      FactoryBot.find_definitions

      user = create(:user, email: "test@test.com", password: "password")
      income = 2000
      expenses = 1000
      net_worth = 100 * rand(100)
      FinancialDatum::MONTHS.each do |month|
        income += 10 * rand(10)
        expenses += 10 * rand(5)
        net_worth += 1000 * rand(3)
        create(:financial_datum, user: user, month: month, year: 2018, income: income, expenses: expenses, net_worth: net_worth)
      end
    end
  end
end
