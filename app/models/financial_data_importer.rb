require "csv"

class FinancialDataImporter
  attr_reader :file_path, :user_id

  def initialize(file_path, user_id)
    @file_path = file_path
    @user_id = user_id
  end

  def import
    case File.extname(file_path)
    when ".csv"
      CsvImporter.new(file_path, user_id).import
    when ".xlsx"
      XlsxImporter.new(file_path, user_id).import
    else
      raise "Unknown file type"
    end
  end
end
