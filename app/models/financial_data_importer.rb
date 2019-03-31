class FinancialDataImporter
  attr_reader :file_path, :user, :formatter

  def initialize(file_path, user)
    @file_path = file_path
    @user = user
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
