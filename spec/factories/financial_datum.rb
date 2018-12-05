FactoryBot.define do
  factory :financial_datum do
    user
    sequence(:month) { |n| n % 12 }
    year do
      current_year = Time.zone.now.year
      (2010..current_year).to_a.sample
    end
    income { 100 * rand(100) }
    expenses { 100 * rand(50) }
    net_worth { 1000 * rand(100) }
  end
end
