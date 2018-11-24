class FinancialDataController < ApplicationController
  before_action :require_login

  def index
    financial_data = current_user.financial_data

    render locals: { financial_data: financial_data }
  end

  def new
    financial_datum = FinancialDatum.new

    render locals: { financial_datum: financial_datum }
  end

  def create
    datum = FinancialDatum.new(financial_datum_params)

    if datum.save
      redirect_to financial_data_path
    else
      render :new, locals: { errors: datum.errors.full_messages }
    end
  end

  private

  def financial_datum_params
    params.
      require(:financial_datum).
      permit(:month, :year, :income, :expenses, :net_worth).
      merge(user: current_user)
  end
end
