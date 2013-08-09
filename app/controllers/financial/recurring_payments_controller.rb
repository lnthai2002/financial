require_dependency "financial/application_controller"

module Financial
  class RecurringPaymentsController < ApplicationController
    #usecase tabs
    set_tab :daily_tracking, :usecases, :only => %w(index new edit)
    #resource tabs
    set_tab :recurring_payments, :daily_resources, :only => %w(index new edit)
    #action tabs
    set_tab :list, :recurring_payment, :only => %w(index)
    set_tab :add, :recurring_payment, :only => %w(new)
    set_tab :edit, :recurring_payment, :only => %w(edit)

    def index
      @recurring_incomes = RecurringIncome.find(:all)
      @recurring_expenses = RecurringExpense.find(:all)
    end

    def new
      @recurring_payment = RecurringPayment.new
      @payment_types = PaymentType.all
      @categories = IncomeCategory.all  #first recurring type selection is Income, thus prepopulate with income cat
    end

    def create
      recurring_type = params[:recurring_payment][:type]
      params[:recurring_payment].delete(:type)
      case recurring_type
        when "Financial::RecurringIncome"
          @recurring_payment = RecurringIncome.new(params[:recurring_payment])
        when "Financial::RecurringExpense"
          @recurring_payment = RecurringExpense.new(params[:recurring_payment])
      end
      
      if @recurring_payment.save
        redirect_to recurring_payments_path
      else
        render action: "new"
      end
    end

    def edit
      
    end

    def update
      
    end

    def destroy
      @recurring_payment = RecurringPayment.find(params[:id])
      @recurring_payment.destroy
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
