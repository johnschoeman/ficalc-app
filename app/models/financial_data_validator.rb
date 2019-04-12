class FinancialDataValidator
  VALID_DATA_REGEX = /^\$?\d+\.?\d*$/ 
  attr_reader :data

  def initialize(data)
    @data = data
  end

  def valid?
    data.all? { |key, value| VALID_DATA_REGEX.match?(value) }
  end
end
