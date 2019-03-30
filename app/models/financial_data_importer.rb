class FinancialDataImporter
  attr_reader :file_path, :user

  def initialize(file_path, user)
    @file_path = file_path
    @user = user
  end

  def import
    CSV.foreach(file_path, headers: true) do |row|
      datum_as_hash = row.to_h
      datum_as_hash["user_id"] = user.id
      datum_as_hash["month"] =
        FinancialDatum::MONTHS[datum_as_hash["month"].to_i]
      datum = FinancialDatum.new(datum_as_hash)
      datum.save
    end
  end
end
