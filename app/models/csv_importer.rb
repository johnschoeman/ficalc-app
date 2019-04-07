require "csv"

class CsvImporter < FileImporter
  attr_reader :builder

  def initialize(filename, user_id)
    super
    @builder = CsvBuilder.new
  end

  def import
    CSV.foreach(file_path, headers: true) do |row|
      raw_data = builder.build(row, user_id)
      datum = FinancialDatum.new(raw_data)
      datum.save
    end
  end
end
