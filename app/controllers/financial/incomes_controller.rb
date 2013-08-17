require_dependency "financial/application_controller"

module Financial
  class IncomesController < ApplicationController
    #usecase tabs
    set_tab :daily_tracking, :usecases, :only => %w(index new edit)
    #resource tabs
    set_tab :incomes, :daily_resources, :only => %w(index new edit)
    #action tabs
    set_tab :list, :income, :only => %w(index)
    set_tab :add, :income, :only => %w(new)
    set_tab :edit, :income, :only => %w(edit)

    def index
      #default is the current month
      !params[:year] ? year = Date.today.year : @year = params[:year]
      !params[:month] ? month = Date.today.month : @month = params[:month]
      begin_date = Date.parse("#{year}-#{month}-01")
      end_date = begin_date.end_of_month
      #inclusive search
      @incomes = Income.find(:all, :conditions=>["pmt_date BETWEEN DATE(?) AND DATE(?)", begin_date.strftime("%Y-%m-%d"), end_date.strftime("%Y-%m-%d")], :order=>:pmt_date)
      @monthly_total = Money.new(Income.sum(:amount_cents, :conditions=>["pmt_date BETWEEN DATE(?) AND DATE(?)", begin_date.strftime("%Y-%m-%d"), end_date.strftime("%Y-%m-%d")]))
      @summaries = Income.sum(:amount_cents, :conditions=>["pmt_date BETWEEN DATE(?) AND DATE(?)", begin_date.prev_month.strftime("%Y-%m-%d"), end_date.prev_month.strftime("%Y-%m-%d")], :group=>:category_id)
    end

    def new
      load_selections
      @income = Income.new
    end

    def edit
      load_selections
      @income = Income.find(params[:id])
    end

    def create
      @income = Income.new(params[:income])
      if @income.save
        redirect_to incomes_path
      else
        render action: "new"
      end
    end

    def update
      @income = Income.find(params[:id])
  
      respond_to do |format|
        if @income.update_attributes(params[:income])
          format.html { redirect_to incomes_path, notice: 'Income was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @income.errors, status: :unprocessable_entity }
        end
      end
    end

    private

    def load_selections
      @income_categories = IncomeCategory.all
      @payment_types = PaymentType.all
    end
  end
end
