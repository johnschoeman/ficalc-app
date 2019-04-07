class FinancialDataFormatter
  def format(raw_data, user_id)
    raw_data[:user_id] = user_id
    raw_data[:month] = FinancialDatum::MONTHS[raw_data["month"].to_i]
    raw_data.symbolize_keys!
  end
end
