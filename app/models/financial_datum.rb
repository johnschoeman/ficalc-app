class FinancialDatum < ApplicationRecord
  MONTHS =
    %i[
      january february march april may june july august september october november december
    ].freeze

  validates_presence_of :month, :year, :date, :income, :expenses, :net_worth
  validates :user_id, uniqueness: { scope: [:year, :month], message: "You can only have one entry per month." }
  validate :year_is_within_financial_history_range

  belongs_to :user

  enum month: MONTHS

  before_validation do
    downcase_month
    create_date_from_month_and_year
  end

  def self.get_data_for(user)
    user.financial_data.order(:year, :month)
  end

  def self.build_for(user, month = "january", year = Time.zone.now.year, income = 500, expenses = 200, net_worth = 10_000)
    new(
      user_id: user.id,
      month: month,
      year: year,
      income: income,
      expenses: expenses,
      net_worth: net_worth,
    )
  end

  def self.build_for_time_range(
    user,
    start_month = 0,
    start_year = 2016,
    end_month = 11,
    end_year = 2018
  )
    data = []
    (start_year..end_year).each do |year|
      (start_month..end_month).each do |month|
        data << build_for(user, MONTHS[month], year)
      end
    end
    data
  end

  def percent_fi
    withdraw_rate_multiplier = 300 # 0.04withdraw_rate/ 12months
    if expenses.positive? && withdraw_rate_multiplier.positive?
      percent_fi = net_worth / (withdraw_rate_multiplier * expenses).to_f
      [percent_fi, 1.0].min
    else
      1.0
    end
  end

  def savings_rate
    if income.positive?
      (income - expenses) / income.to_f
    else
      0.0
    end
  end

  def safe_withdraw_amount
    withdraw_rate_multiplier = 300
    net_worth / withdraw_rate_multiplier
  end

  def net_worth_delta
    if previous_datum
      net_worth - previous_datum.net_worth
    end
  end

  def average_expenses
    previous_data_for_year.average(:expenses).to_f
  end

  def average_income
    previous_data_for_year.average(:income).to_f
  end

  def year_is_within_financial_history_range
    if year && year > current_year
      errors.add(:year, "cannot be in the future")
    end
    if year && year < 1970
      errors.add(:year, "cannot be before 1970")
    end
  end

  private

  def downcase_month
    self.month = month.try(:downcase)
  end

  def create_date_from_month_and_year
    if year && month
      self.date = Date.new(year, FinancialDatum.months[month] + 1)
    end
  end

  def current_year
    Time.zone.now.year
  end

  def previous_data_for_year
    FinancialDatum.
      where(user: user).
      where("date > ? and date <= ?", date - 1.year, date).
      order(:date)
  end

  def previous_datum
    prev_month, prev_year = previous_date
    FinancialDatum.find_by(user: user, month: prev_month, year: prev_year)
  end

  def previous_date
    month_idx = FinancialDatum.months[month]
    if january?
      [11, year - 1]
    else
      [month_idx - 1, year]
    end
  end
end
