require_dependency "financial/application_controller"

module Financial
  class MortgageAdjsController < AuthorizableController
    #update or create a new adjustment if an adjustment already exist for the given month, update it
    def create
      mortgage = Mortgage.accessible_by(current_ability).find(params[:adjustment][:mortgage_id])
      @adjustment = MortgageAdj.accessible_by(current_ability)
                               .where(:mortgage_id=>params[:adjustment][:mortgage_id],
                                      :month=>params[:adjustment][:month])
                               .first
      if @adjustment.blank?
        @adjustment = MortgageAdj.new(mortgage_adj_params)
        @adjustment.mortgage = mortgage
        @adjustment.person = @person
      else
        @adjustment.attributes=mortgage_adj_params
      end
      
      if @adjustment.save
        @adjustment=MortgageAdj.new
      end

      @plan = mortgage.plan
      render "financial/plans/update_detail"
    end

    def destroy
      existing_adj = MortgageAdj.accessible_by(current_ability).find(params[:id])
      existing_adj.destroy
      redirect_to :controller=>'plans', :action=>'show', :id=>existing_adj.mortgage_id
    end

    private

    def mortgage_adj_params
      #do not allow switching mortgage by changing mortgage_id
      params.require(:adjustment).permit(:month, :amount, :interest, :duration)
    end
  end
end
