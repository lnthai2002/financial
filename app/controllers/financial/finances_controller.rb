require_dependency "financial/application_controller"

module Financial
  class FinancesController < AuthorizableController
    skip_before_filter :check_user_finance, :only => [:new, :create]

    def new
      person = Person.where(:email=>session[:cas_user]).first
      @finance = Finance.new(:person_id=>person.id)
    end

    def create
      person = Person.where(:email=>session[:cas_user]).first
      if person.finance.blank?
        @finance = Finance.new(params[:finance])
        @finance.person = person
      else
        @finance = person.finance
        @finance.attributes=params[:finance]
      end
      if @finance.save
        redirect_to plans_path
      else
        render :new
      end
    end
  end
end
