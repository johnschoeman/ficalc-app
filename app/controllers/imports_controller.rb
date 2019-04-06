class ImportsController < ApplicationController
  def create
    importer = FinancialDataImporter.new(params[:file].path, current_user.id)
    importer.import
    redirect_to financial_data_path, notice: "Succesfully imported"
  end
end
