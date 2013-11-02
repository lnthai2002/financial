require_dependency "financial/application_controller"

module Financial
  class PlansController < AuthorizableController
    def index
      @plan = Plan.new
      #see http://stackoverflow.com/questions/4867880/nested-attributes-in-rails-3
      @plan.build_mortgage
      @plan.build_investment
      @plans = Plan.accessible_by(current_ability).all
    end

    def create
      @plan = Plan.new(params[:plan])
      @plan.person = @person
      if @plan.save #valid plan
        @saved_plan = @plan #used to render recently added plan
        @plan = Plan.new(params[:plan]) #used to populate form
      else
        #return the plan with error to be displayed
      end
      render "add_new_plan"
    end

    def destroy
      @plan = Plan.accessible_by(current_ability).find(params[:id])
      @plan.destroy
      render "delete_plan"
    end

    def show
      @plan = Plan.accessible_by(current_ability).find(params[:id])
    end
  end
end
