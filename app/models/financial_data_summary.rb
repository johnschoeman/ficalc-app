class FinancialDataSummary
  WITHDRAW_RATE_MULTIPLIER = 300

  def initialize(user)
    @user = user
  end

  def valid?
    @user.class == User
  end

  def net_worth
    last_datum_query.pluck(:net_worth).first
  end

  def average_income
    previous_data_for_year_query.average(:income).to_i
  end

  def average_expenses
    previous_data_for_year_query.average(:expenses).to_i
  end

  def percent_fi
    if average_expenses.positive?
      percent_fi =
        net_worth / (WITHDRAW_RATE_MULTIPLIER * average_expenses).to_f
      [percent_fi, 1.0].min
    else
      1.0
    end
  end

  def time_to_fi
    last_datum_query.first.time_to_fi
  end

  private

  def previous_data_for_year_query
    FinancialDatum.
      where(user: @user).
      where("date <= ?", Time.current).
      order(:date).
      limit(12)
  end

  def last_datum_query
    FinancialDatum.
      where(user: @user).
      order("date DESC").
      limit(1)
  end
end
