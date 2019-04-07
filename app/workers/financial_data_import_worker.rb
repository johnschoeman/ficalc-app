class FinancialDataImportWorker
  include Sidekiq::Worker

  def perform(file_path, user_id)
    FinancialDataImporter.import(file_path, user_id)
  end
end
