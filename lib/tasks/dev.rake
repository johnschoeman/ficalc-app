if Rails.env.development? || Rails.env.test?
  require "factory_bot"

  namespace :dev do
    include FactoryBot::Syntax::Methods
    FactoryBot.find_definitions

    desc "Sample data for local development environment"
    task prime: "db:setup" do
      user = create(:user, email: "test@test.com", password: "password")
      income = 2000
      expenses = 1000
      net_worth = 100 * rand(100)
      FinancialDatum::MONTHS.each do |month|
        income += 10 * rand(10)
        expenses += 10 * rand(5)
        net_worth += 1000 * rand(3)
        create(
          :financial_datum,
          user: user,
          month: month,
          year: 2018,
          income: income,
          expenses: expenses,
          net_worth: net_worth
        )
      end
    end

    desc "Create a test user with some test data"
    task create_test_user: :environment do
      user = User.find_or_create_by(email: "test@test.com")
      user.password = "password"
      user.save
      FinancialDatum.where(user: user).destroy_all

      income = 2000
      expenses = 1000
      net_worth = 100 * rand(100)
      last_year_of_months.each do |month, year|
        income += 10 * rand(10)
        expenses += 10 * rand(5)
        net_worth += 1000 * rand(3)
        create(
          :financial_datum,
          user: user,
          month: month,
          year: year,
          income: income,
          expenses: expenses,
          net_worth: net_worth
        )
      end
    end
  end

  def last_year_of_months
    today = Date.today
    year = today.year - 1
    month = today.month

    (month...month + 12).map do |i|
      month = i % 12
      if month == 11
        year += 1
      end
      month_year = [FinancialDatum::MONTHS[month], year]
    end
  end
end
