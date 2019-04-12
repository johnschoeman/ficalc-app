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
    headers = nil
    worksheet.each_with_index do |row, idx|
      if idx == 0
        headers = row.cells.map(&:value)
        next
      end
      cells = row.cells.map(&:value)
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
    data.
      then { |hash| validate(hash) }.
      then { |hash| format_month(hash) }.
      then { |hash| format_currency(hash) }.
      then { |hash| apply_user_id(hash, user_id) }.
      then { |hash| FinancialDatum.create(hash) }
  end

  def validate(data)
    regex = /^\$?\d+\.?\d*$/
    result = if data.all? { |key, value| regex.match?(value) }
      data
    else
      {}
    end
    result
  end

  def format_month(hash)
    if hash.empty?
      return {}
    end
    new_hash = hash.dup
    if hash["month"] && hash["year"]
      new_hash["month"] = get_month(hash["month"].to_i)
    end
    if hash["date"]
      date = parse_date(hash["date"].to_s)
      new_hash["month"] = get_month(date.month - 1)
      new_hash["year"] = date.year
      new_hash.delete("date")
    end
    new_hash
  end

  def get_month(month_number)
    FinancialDatum::MONTHS[month_number]
  end

  def parse_date(date)
    if /\d{8}/.match?(date)
      Date.strptime("#{date[0..3]}-#{date[4..5]}-#{date[6..7]}")
    elsif /\d{4}-\d{2}-\d{2}/.match?(date)
      Date.strptime(date)
    else
      raise "Unknown date format: #{date}"
    end
  end

  def format_currency(hash)
    if hash.empty?
      return {}
    end
    new_hash = hash.dup
    new_hash["expenses"] = to_float(new_hash["expenses"])
    new_hash["income"] = to_float(new_hash["income"])
    new_hash["net_worth"] = to_float(new_hash["net_worth"])
    new_hash
  end

  def to_float(value)
    if value.class == String
      value.gsub("$", "").gsub(",", "").to_f
    else
      value.to_f
    end
  end

  def apply_user_id(hash, user_id)
    if hash.empty?
      return {}
    end
    new_hash = hash.dup
    new_hash["user_id"] = user_id
    new_hash
  end
end
