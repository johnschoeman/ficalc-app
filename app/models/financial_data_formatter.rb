class FinancialDataFormatter
  def format(raw_data, user_id)
    raw_data.keys.each do |key|
      case key
      when :month
        raw_data[:month] = get_month(raw_data[:month])
      when :expenses
        raw_data[:expenses] = convert_to_integer(raw_data[:expenses])
      when :income
        raw_data[:income] = convert_to_integer(raw_data[:income])
      when :net_worth
        raw_data[:net_worth] = convert_to_integer(raw_data[:net_worth])
      when :year
      when :date
        parsed_date = parse_date(raw_data[:date])
        raw_data[:month] = get_month(parsed_date.month - 1)
        raw_data[:year] = parsed_date.year
        raw_data.delete(:date)
      else
        raise "Unknown column: #{key}"
      end
    end
    raw_data[:user_id] = user_id
    raw_data
  end

  private

  def get_month(integer)
    FinancialDatum::MONTHS[integer.to_i]
  end

  def convert_to_integer(value)
    value.class == String ? value.gsub("$", "").gsub(",", "").to_i : value.to_f
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
end
