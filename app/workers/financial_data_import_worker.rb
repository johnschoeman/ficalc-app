class FinancialDataImportWorker
  include Sidekiq::Worker

  def perform(file_path, user_id)
    FinancialDataImporter.new(file_path, user_id).import
  end
end
