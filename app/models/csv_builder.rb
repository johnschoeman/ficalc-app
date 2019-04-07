class CsvBuilder < DataBuilder
  def build(csv_row, user_id)
    datum_as_hash = csv_row.to_h
    formatter.format(datum_as_hash, user_id)
  end
end
