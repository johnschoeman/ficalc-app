class XlsxBuilder < DataBuilder
  def build(xlsx_row, user_id)
    cells = xlsx_row.cells.map(&:value)
    headers = %w[month year income expenses net_worth]
    datum_as_hash = headers.zip(cells).to_h.symbolize_keys
    formatter.format(datum_as_hash, user_id)
  end
end
