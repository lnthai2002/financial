require_dependency "financial/application_controller"

module Financial
  class RecurringPaymentsController < AuthorizableController
    def index
      @recurring_incomes = RecurringIncome.accessible_by(current_ability).find(:all)
      @recurring_expenses = RecurringExpense.accessible_by(current_ability).find(:all)
    end

    def new
      @recurring_payment = RecurringIncome.new(:first_date=>Date.today)
      load_selections
      #@payment_types = PaymentType.all
      #@categories = IncomeCategory.all  #first recurring type selection is Income, thus prepopulate with income cat
    end

    def create
      @recurring_payment = RecurringPayment.new(params[:recurring_payment])
      @recurring_payment.person = @person
      if @recurring_payment.save
        redirect_to recurring_payments_path
      else
        load_selections
        render action: "new"
      end
    end

    def edit
      @recurring_payment = RecurringPayment.accessible_by(current_ability).find(params[:id])
      load_selections
    end

    def update
      @recurring_payment = RecurringPayment.accessible_by(current_ability).find(params[:id])
      if @recurring_payment.update_attributes(params[:recurring_payment])
        redirect_to recurring_payments_path
      else
        load_selections 
        render action: "edit"
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
    
    private
    
    def load_selections
      if @recurring_payment.type == 'Financial::RecurringIncome'
        @categories = IncomeCategory.all
      elsif @recurring_payment.type == 'Financial::RecurringExpense'
        @categories = ExpenseCategory.all
      end
      @payment_types = PaymentType.all
    end
  end
end
