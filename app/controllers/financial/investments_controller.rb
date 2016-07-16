module Financial
  class InvestmentsController < AuthorizableController
    #load the investment, set the virtual attributes: alt_rate, alt_monthly_dep, alt_length
    def update
      @investment = Investment.accessible_by(current_ability).find(params[:id])
      @investment.attributes=investment_params
      render "update_investment"
    end

    private

    def investment_params
      #virtual attributes, not persist
      params.require(:investment).permit(:alt_rate, :alt_monthly_dep, :alt_length)
    end
  end
end
