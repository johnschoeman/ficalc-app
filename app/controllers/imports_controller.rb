class ImportsController < ApplicationController
  def create
    FinancialDataImporter.import(params[:file].path, current_user)
    redirect_to financial_data_path, notice: "Succesfully imported"
  end
end
