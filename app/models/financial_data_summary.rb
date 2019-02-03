class FinancialDataSummary
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
    last_datum_query.first.percent_fi
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
