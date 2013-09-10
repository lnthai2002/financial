require_dependency "financial/application_controller"

module Financial
  class RecurringPaymentsController < AuthorizableController
    #usecase tabs
    set_tab :daily_tracking, :usecases, :only => %w(index new edit)
    #resource tabs
    set_tab :recurring_payments, :daily_resources, :only => %w(index new edit)
    #action tabs
    set_tab :list, :recurring_payment, :only => %w(index)
    set_tab :add, :recurring_payment, :only => %w(new)
    set_tab :edit, :recurring_payment, :only => %w(edit)

    def index
      @recurring_incomes = RecurringIncome.accessible_by(current_ability).find(:all)
      @recurring_expenses = RecurringExpense.accessible_by(current_ability).find(:all)
    end

    def new
      @recurring_payment = RecurringPayment.new
      @payment_types = PaymentType.all
      @categories = IncomeCategory.all  #first recurring type selection is Income, thus prepopulate with income cat
    end

    def create
      @recurring_payment = RecurringPayment.new(params[:recurring_payment])
      @recurring_payment.person = @person
      if @recurring_payment.save
        redirect_to recurring_payments_path
      else
        render action: "new"
      end
    end

    def edit
      @recurring_payment = RecurringPayment.accessible_by(current_ability).find(params[:id])
      @payment_types = PaymentType.all
      if @recurring_payment.class == Financial::RecurringIncome
        @categories = IncomeCategory.all
      elsif @recurring_payment.class == Financial::RecurringExpense
        @categories = ExpenseCategory.all
      end
    end

    def update
      @recurring_payment = RecurringPayment.accessible_by(current_ability).find(params[:id])
      if @recurring_payment.update_attributes(params[:recurring_payment])
        redirect_to recurring_payments_path
      else
        redirect_to edit_recurring_payment_path(params[:id])
      end
    end

    def terminate
      @recurring_payment = RecurringPayment.accessible_by(current_ability).find(params[:id])
      @recurring_payment.end_date = Date.today
      if @recurring_payment.save
        redirect_to recurring_payments_path
      end
    end

    def destroy
      @recurring_payment = RecurringPayment.accessible_by(current_ability).find(params[:id])
      ActiveRecord::Base.transaction do
        #should we really allow delete if there are payments?
        @recurring_payment.payments.each do |payment| #break the association first, otherwise will fail to delete
          payment.recurring_payment = nil
        end
        @recurring_payment.payments.destroy
        @recurring_payment.destroy
      end
      redirect_to recurring_payments_path
    end

    def reload_categories
      case params[:recurring_payment_type]
        when "Financial::RecurringIncome"
          @categories = IncomeCategory.all
        when "Financial::RecurringExpense"
          @categories = ExpenseCategory.all
      end
      respond_to do |format|
        format.json { render json: @categories }
      end
    end
  end
end
