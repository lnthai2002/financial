require_dependency "financial/application_controller"

module Financial
  class ExpensesController < AuthorizableController
    #usecase tabs
    set_tab :daily_tracking, :usecases, :only => %w(index new edit)
    #resource tabs
    set_tab :expenses, :daily_resources, :only => %w(index new edit)
    #action tabs
    set_tab :list, :expense, :only => %w(index)
    set_tab :add, :expense, :only => %w(new)
    set_tab :edit, :expense, :only => %w(edit)

    # GET /expenses
    # GET /expenses.json
    def index
      #default is the current month
      begin
        start_date = Date.parse(params[:start_date])
      rescue
        start_date = Date.today.beginning_of_month
      end
      begin
        end_date = Date.parse(params[:end_date])
      rescue
        end_date = Date.today.end_of_month
      end
      #inclusive search
      range_condition = ["pmt_date BETWEEN DATE(?) AND DATE(?)",
                         start_date.strftime("%Y-%m-%d"),
                         end_date.strftime("%Y-%m-%d")]
      @expenses = Expense.accessible_by(current_ability).where(range_condition).order(:pmt_date).all
      @monthly_total = Money.new(Expense.accessible_by(current_ability).where(range_condition).sum(:amount_cents))
      @summary = Summary.by_date_range(current_ability, start_date, end_date)

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @expenses }
      end
    end
  
    # GET /expenses/new
    # GET /expenses/new.json
    def new
      load_selections
      @expense = Expense.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @expense }
      end
    end
  
    # Ajax called to render additional fields depending on the expense type selected
    def select_type
      type = ExpenseCategory.find(:first, :select=>'description', :conditions=>{:id=>params[:expense][:category_id]})
      if type != nil && type == 'Anual bill'
        render :partial => 'date_range', :layout => false
      end
    end
  
    # GET /expenses/1/edit
    def edit
      load_selections
      @expense = Expense.accessible_by(current_ability).find(params[:id])
    end
  
    # POST /expenses
    # POST /expenses.json
    def create
      @expense = Expense.new(params[:expense])
      @expense.person = @person
      respond_to do |format|
        if @expense.save
          format.html { redirect_to expenses_path, notice: 'Expense was successfully created.' }
          format.json { render json: @expense, status: :created, location: @expense }
        else
          format.html { render action: "new" }
          format.json { render json: @expense.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /expenses/1
    # PUT /expenses/1.json
    def update
      @expense = Expense.accessible_by(current_ability).find(params[:id])
  
      respond_to do |format|
        if @expense.update_attributes(params[:expense])
          format.html { redirect_to expenses_path, notice: 'Expense was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @expense.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /expenses/1
    # DELETE /expenses/1.json
    def destroy
      @expense = Expense.accessible_by(current_ability).find(params[:id])
      @expense.destroy
  
      respond_to do |format|
        format.html { redirect_to expenses_url }
        format.json { head :ok }
      end
    end
    
    # GET /expenses/1/breakdown
    def breakdown
      load_selections
      
      @parent_expense = Expense.accessible_by(current_ability).find(params[:id])
      @expense = Expense.new
    end
    
    # PUT /expenses/1/update_breakdown
    def update_breakdown
      @parent_expense = Expense.accessible_by(current_ability).find(params[:id])
      @expense = Expense.new(params[:expense])
      error = false
  #    flash[:error] = nil
      if(params[:expense].amount.to_f >= @parent_expense.amount.to_f)
        flash[:error] = 'Sub-amount can not exceed parent amount.'
        error = true
        puts "888888888888 " + params[:expense].amount.to_f.to_s
        puts "----------- " + @parent_expense.amount.to_f.to_s
      end
      if (params[:expense].payment_type_id.to_i != @parent_expense.payment_type_id.to_i)
        flash[:error] = 'Sub-expense must have the same payment method as parent expense.'
        error = true
        puts "888888888888 " + params[:expense].payment_type_id.to_s
        puts "----------- " + @parent_expense.payment_type_id.to_s
      end
      if error == false
        begin
          Expense.transaction do
            @parent_expense.update_attribute(:amount, (@parent_expense.amount - @expense.amount))
            @expense.save
            redirect_to(expenses_path)
          end
        rescue ActiveRecord::RecordInvalid => e
          flash[:error] = e.message
          load_selections
          render :action=>'breakdown'
        end
      else
        load_selections
        render :action=>'breakdown'
      end
    end
  
  protected

    def load_selections
      @expense_categories = ExpenseCategory.all
      @payment_types = PaymentType.all
    end
  end
end
