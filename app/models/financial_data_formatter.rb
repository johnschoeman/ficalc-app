class FinancialDataFormatter
  def build_csv(csv_row, user_id)
    datum_as_hash = csv_row.to_h
    format_base_hash(datum_as_hash, user_id)
  end

  def build_xlsx(xlsx_row, user_id)
    cells = xlsx_row.cells.map(&:value)
    headers = %w[month year income expenses net_worth]
    datum_as_hash = headers.zip(cells).to_h
    format_base_hash(datum_as_hash, user_id)
  end

  private

  def format_base_hash(datum_as_hash, user_id)
    datum_as_hash["user_id"] = user_id
    datum_as_hash["month"] = FinancialDatum::MONTHS[datum_as_hash["month"].to_i]
    datum_as_hash
  end
end
