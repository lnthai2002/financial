module Financial
  class FinancesController < AuthorizableController
    skip_before_filter :check_user_finance, :only => [:new, :create]

    def new
      person = Person.where(:email=>session[:cas_user]).first
      @finance = Finance.new(:person_id=>person.id)
      render :form
    end

    def create
      record_financial_status_of_current_user
    end

    def edit
      person = Person.where(:email=>session[:cas_user]).first
      @finance = person.finance
      render :form
    end

    def update
      record_financial_status_of_current_user
    end

    private

    def record_financial_status_of_current_user
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
        render :form
      end
    end

    def finance_params
      params.require(:finance).permit(:net_monthly_income, :net_monthly_expense)
    end
  end
end
