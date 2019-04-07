class DataBuilder
  attr_reader :formatter

  def initialize
    @formatter = FinancialDataFormatter.new
  end

  def build
    raise "Override this method"
  end
end
