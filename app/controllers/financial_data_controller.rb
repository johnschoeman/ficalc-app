class FinancialDataController < ApplicationController
  before_action :require_login

  def index
    financial_data = FinancialDatum.get_data_for(current_user)

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
      render :new, locals: { financial_datum: datum }
    end
  end

  def edit
    datum = FinancialDatum.find(params[:id])

    if datum
      render locals: { financial_datum: datum }
    else
      redirect_to financial_data_path
    end
  end

  def update
    datum = FinancialDatum.find(params[:id])

    if datum.update(financial_datum_params)
      redirect_to financial_data_path
    else
      render :edit, locals: { financial_datum: datum }
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
