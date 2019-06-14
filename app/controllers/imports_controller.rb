class ImportsController < ApplicationController
  def create
    FinancialDatum.import(params[:file].path, current_user.id)
    redirect_to financial_data_path, notice: "Succesfully imported"
  end
end
