require "csv"

class FinancialDataImporter
  attr_reader :file_path, :user_id, :formatter

  def initialize(file_path, user_id)
    @file_path = file_path
    @user_id = user_id
    @formatter = FinancialDataFormatter.new
  end

  def import
    case File.extname(file_path)
    when ".csv"
      import_csv
    when ".xlsx"
      import_xlsx
    end
  end

  private

  def import_xlsx
    workbook = RubyXL::Parser.parse(file_path)
    worksheet = workbook.worksheets.first
    worksheet.each_with_index do |row, idx|
      if idx == 0
        next
      end
      formatted_datum = formatter.build_xlsx(row, user_id)
      datum = FinancialDatum.new(formatted_datum)
      datum.save
    end
  end

  def import_csv
    CSV.foreach(file_path, headers: true) do |row|
      formatted_datum = formatter.build_csv(row, user_id)
      datum = FinancialDatum.new(formatted_datum)
      datum.save
    end
  end
end
