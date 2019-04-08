class FinancialDataImportWorker
  include Sidekiq::Worker

  def perform(file_path, user_id)
    FinancialDatum.import(file_path, user_id)
  end
end
