class CsvBuilder < DataBuilder
  def build(csv_row, user_id)
    datum_as_hash = csv_row.to_h.symbolize_keys
    valid_data = validator.new(datum_as_hash)
    if valid_data.valid?
      formatter.format(valid_data.data, user_id)
    end
  end
end
