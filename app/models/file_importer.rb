class FileImporter
  attr_reader :file_path, :user_id

  def initialize(file_path, user_id)
    @file_path = file_path
    @user_id = user_id
  end

  def import
    raise "Must be overridden"
  end
end
