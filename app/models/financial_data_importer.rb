class FinancialDataImporter
  attr_reader :file_path, :user_id

  def initialize(file_path, user_id)
    @file_path = file_path
    @user_id = user_id
  end

  def import
    CSV.foreach(file_path, headers: true) do |row|
      datum_as_hash = row.to_h
      datum_as_hash["user_id"] = user_id
      datum_as_hash["month"] =
        FinancialDatum::MONTHS[datum_as_hash["month"].to_i]
      datum = FinancialDatum.new(datum_as_hash)
      datum.save
    end
  end
end
