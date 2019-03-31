class FinancialDataFormatter
  def build(csv_row, user_id)
      datum_as_hash = csv_row.to_h
      datum_as_hash["user_id"] = user_id
      datum_as_hash["month"] =
        FinancialDatum::MONTHS[datum_as_hash["month"].to_i]
      datum_as_hash
  end
end
