class FinancialDatum < ApplicationRecord
  MONTHS =
    %i[
      january february march april june july august september november december
    ].freeze

  validates_presence_of :month, :year, :income, :expenses, :net_worth
  validates :user_id, uniqueness: { scope: [:year, :month], message: "You can only have one entry per month." }
  validate :year_is_within_financial_history_range

  belongs_to :user

  enum month: MONTHS

  before_validation do
    self.month = month.try(:downcase)
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
      net_worth: net_worth
    )
  end

  def percent_fi
    withdraw_rate_multiplier = 300 # 0.04withdraw_rate/ 12months
    percent_fi = net_worth / (withdraw_rate_multiplier * expenses).to_f
    [percent_fi, 1.0].min
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

  def current_year
    Time.zone.now.year
  end
end
