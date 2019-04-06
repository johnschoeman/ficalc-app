# frozen_string_literal: true
require "net/sftp"

class PollFinancialDataFiles
  SFTP_PATH = ENV.fetch("SFTP_PATH")
  LOCAL_PATH = Rails.root.join("data", "financial_imports").to_s

  def self.run
    new.poll_sftp
  end

  def poll_sftp
    download_files
    process_files
    delete_files
  end

  private

  def download_files
    Net::SFTP.start(
      ENV.fetch("SFTP_HOST"),
      ENV.fetch("SFTP_USERNAME"),
      password: ENV.fetch("SFTP_PASSWORD"),
    ) do |sftp|
      sftp.dir.foreach(SFTP_PATH) do |file|
        if file.name == "." || file.name == ".."
          next
        end
        file_name = file.name
        sftp_path = SFTP_PATH + "/#{file_name}"
        local_path = LOCAL_PATH + "/#{file_name}"
        sftp.download!(sftp_path, local_path)
      end
    end
  end

  def process_files
    Dir.each_child(LOCAL_PATH) do |file_name|
      file_path = LOCAL_PATH + "/#{file_name}"
      user_id = parse_user_id_from(file_name)
      if user_id.present?
        print "."
        FinancialDataImportWorker.new.perform(file_path, user_id)
      end
    end
  end

  def parse_user_id_from(file_name)
    regex = /.*-(\d+)/
    result = regex.match(file_name)
    if result.present?
      result.captures.first.to_i
    end
  end

  def delete_files
    Dir.each_child(LOCAL_PATH) do |file_name|
      File.delete(LOCAL_PATH + "/#{file_name}")
    end
  end
end
