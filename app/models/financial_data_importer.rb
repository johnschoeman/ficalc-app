class FinancialDataImporter
  attr_reader :file_path, :user_id, :formatter

  def initialize(file_path, user_id)
    @file_path = file_path
    @user_id = user_id
    @formatter = FinancialDataFormatter.new
  end

  def import
    CSV.foreach(file_path, headers: true) do |row|
      formatted_datum = formatter.build(row, user.id)
      datum = FinancialDatum.new(formatted_datum)
      datum.save
    end
  end
end
