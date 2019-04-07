require "csv"

class FinancialDataImporter
  def self.import(file_path, user)
    new.import(file_path, user)
  end

  def import(file_path, user)
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
