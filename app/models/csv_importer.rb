require "csv"

class CsvImporter < FileImporter
  def import
    CSV.foreach(file_path, headers: true) do |row|
      formatted_datum = formatter.build_csv(row, user_id)
      datum = FinancialDatum.new(formatted_datum)
      datum.save
    end
  end
end
