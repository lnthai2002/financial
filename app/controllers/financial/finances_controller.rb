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
        @finance = Finance.new(finance_params)
        @finance.person = person
      else
        @finance = person.finance
        @finance.attributes=finance_params
      end
      if @finance.save
        redirect_to plans_path
      else
        render :new
      end
    end

    private

    def finance_params
      params.require(:finance).permit(:net_monthly_income, :net_monthly_expense)
    end
  end
end
