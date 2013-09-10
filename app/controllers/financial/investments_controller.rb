require_dependency "financial/application_controller"

module Financial
  class InvestmentsController < AuthorizableController
    #load the investment, set the virtual attributes: alt_rate, alt_monthly_dep, alt_length
    def update
      @investment = Investment.accessible_by(current_ability).find(params[:id])
      @investment.attributes=params[:investment]
      render "update_investment"
    end
  end
end
