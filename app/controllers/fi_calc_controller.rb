class FiCalcController < ApplicationController
  def timetofi
  end

  def new
    @result = Calculator.send(params[:operation], *[param[:a], params[:b]])
    render :timetofi
  end
  
end
