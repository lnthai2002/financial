require_dependency "financial/application_controller"

module Financial
  class MortgageAdjustmentsController < AuthorizableController
    #update or create a new adjustment if an adjustment already exist for the given month, update it
    def create
      @adjustment = MortgageAdj.accessible_by(current_ability).where(:mortgage_id=>params[:adjustment][:mortgage_id],:month=>params[:adjustment][:month]).first
      if @adjustment.blank?
        @adjustment = MortgageAdj.new(params[:adjustment])
        @adjustment.person = @person
      else
        @adjustment.attributes=params[:adjustment]
      end
      
      if @adjustment.save
        @adjustment=MortgageAdj.new
      end

      @plan = Mortgage.accessible_by(current_ability).find(params[:adjustment][:mortgage_id]).plan
      render "financial/plans/update_detail"
    end

    def destroy
      existing_adj = MortgageAdj.accessible_by(current_ability).find(params[:id])
      existing_adj.destroy
      redirect_to :controller=>:plans, :action=>:show, :id=>existing_adj.mortgage_id
    end
  end
end
