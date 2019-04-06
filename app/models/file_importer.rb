class FileImporter
  attr_reader :file_path, :user_id, :formatter

  def initialize(file_path, user_id)
    @file_path = file_path
    @user_id = user_id
    @formatter = FinancialDataFormatter.new
  end

  def import
    raise "Must be overridden"
  end
end
