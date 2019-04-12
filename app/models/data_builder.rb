class DataBuilder
  attr_reader :formatter, :validator

  def initialize
    @formatter = FinancialDataFormatter.new
    @validator = FinancialDataValidator
  end

  def build
    raise "Override this method"
  end
end
