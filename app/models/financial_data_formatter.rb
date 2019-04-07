class FinancialDataFormatter
  def format(raw_data, user_id)
    raw_data.keys.each do |key|
      case key
      when :month
        raw_data[:month] = FinancialDatum::MONTHS[raw_data[:month].to_i]
      when :expenses
        raw_data[:expenses] = convert_to_integer(raw_data[:expenses])
      when :income
        raw_data[:income] = convert_to_integer(raw_data[:income])
      when :net_worth
        raw_data[:net_worth] = convert_to_integer(raw_data[:net_worth])
      when :year
      else
        raise "Unknown column: #{key}"
      end
    end
    raw_data[:user_id] = user_id
    raw_data
  end

  private

  def convert_to_integer(value)
    value.class == String ? value.gsub("$", "").gsub(",", "").to_i : value.to_f
  end
end
