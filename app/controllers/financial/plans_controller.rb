require_dependency "financial/application_controller"

module Financial
  class PlansController < ApplicationController
    #usecases
    set_tab :planning, :usecases, :only => %w(index show)
    #actions
    set_tab :list, :plans, :only => %w(index)

    def index
      person = Person.where(:email=>session[:cas_user]).first
      @plan = Plan.new
      #see http://stackoverflow.com/questions/4867880/nested-attributes-in-rails-3
      @plan.build_mortgage
      @plan.build_investment
      @plans = Plan.where(:person_id=>person.id).all
    end

    def create
      person = Person.where(:email=>session[:cas_user]).first
      @plan = Plan.new(params[:plan])
      @plan.person = person
      if @plan.save #valid plan
        @saved_plan = @plan #used to render recently added plan
        @plan = Plan.new(params[:plan]) #used to populate form
      else
        #return the plan with error to be displayed
      end
      render "add_new_plan"
    end

    def destroy
      @plan = Plan.find(params[:id])
      @plan.destroy
      render "delete_plan"
    end

    def show
      @plan = Plan.find(params[:id])
    end
  end
end
