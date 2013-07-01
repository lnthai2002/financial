require_dependency "financial/application_controller"

module Financial
  class InvestmentsController < ApplicationController
    #load the investment, set the virtual attributes: alt_rate, alt_monthly_dep, alt_length
    def update
      @investment = Investment.find(params[:id])
      @investment.attributes=params[:investment]
      render "update_investment"
    end
  end
end
