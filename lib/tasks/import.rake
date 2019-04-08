namespace :import do
  desc "Poll FTP server for new financial data files"
  task fi_data: :environment do
    log_message "Starting to import financial data files..."
    PollFinancialDataFiles.run
    log_message "\n\rFinished importing files"
  end

  def log_message(message)
    unless Rails.env.test?
      puts message
    end
  end
end
