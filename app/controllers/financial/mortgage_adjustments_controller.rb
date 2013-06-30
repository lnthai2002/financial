require_dependency "financial/application_controller"

module Financial
  class MortgageAdjustmentsController < ApplicationController
    #update or create a new adjustment if an adjustment already exist for the given month, update it
    def create
      @adjustment = MortgageAdj.where(:mortgage_id=>params[:adjustment][:mortgage_id],:month=>params[:adjustment][:month]).first
      if @adjustment.blank?
        @adjustment = MortgageAdj.new(params[:adjustment])
      else
        @adjustment.attributes=params[:adjustment]
      end
      
      if @adjustment.save
        @adjustment=MortgageAdjustment.new
      end

      @budget = Mortgage.where(:id=>params[:adjustment][:mortgage_id]).first.budget
      render "financial/budgets/update_detail"
    end

    def destroy
      existing_adj = MortgageAdj.find(params[:id])
      existing_adj.destroy
      redirect_to :controller=>:budgets, :action=>:show, :id=>existing_adj.mortgage_id
    end
  end
end
