require "csv"

class FinancialDataImporter
  def self.import(file_path, user_id)
    new.import(file_path, user_id)
  end

  def import(file_path, user_id)
    case File.extname(file_path)
    when ".csv"
      import_csv(file_path, user_id)
    when ".xlsx"
      import_xlsx(file_path, user_id)
    else
      raise "Unknown extenstion #{File.extname(file_path)}"
    end
  end

  def import_xlsx(file_path, user_id)
    workbook = RubyXL::Parser.parse(file_path)
    worksheet = workbook.worksheets.first
    worksheet.each_with_index do |row, idx|
      if idx == 0
        next
      end
      cells = row.cells.map(&:value)
      headers = %w[month year expenses income net_worth]
      data = headers.zip(cells).to_h
      create_financial_datum(data, user_id)
    end
  end

  def import_csv(file_path, user_id)
    CSV.foreach(file_path, headers: true) do |row|
      data = row.to_h
      create_financial_datum(data, user_id)
    end
  end

  private

  def create_financial_datum(data, user_id)
    data["user_id"] = user_id
    data["month"] = FinancialDatum::MONTHS[data["month"].to_i]
    datum = FinancialDatum.new(data)
    datum.save
  end
end
