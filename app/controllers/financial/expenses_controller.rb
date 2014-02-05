module Financial
  class ExpensesController < AuthorizableController
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
      @expenses = {'start_date'=>start_date, 'end_date'=>end_date}
      @expenses['list'] = Expense.accessible_by(current_ability).where(range_condition).order(:pmt_date).all
      @expenses['total'] = Money.new(Expense.accessible_by(current_ability).where(range_condition).sum(:amount_cents))
      @expenses['summary'] = Summary.expenses_by_categories_in_date_range(current_ability, start_date, end_date)

      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @expenses }
      end
    end
  
    # GET /expenses/new
    # GET /expenses/new.json
    def new
      load_selections
      @expense = Expense.new(:pmt_date=>Date.today)
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @expense }
      end
    end
  
    # Ajax called to render additional fields depending on the expense type selected
    def select_type
      type = ExpenseCategory.where(:id=>params[:expense][:category_id])
                            .pluck('description')
                            .first
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
      @expense = Expense.new(expense_params)
      @expense.person = @person
      respond_to do |format|
        if @expense.save
          format.html { redirect_to new_expense_path, notice: "#{@expense.amount} expense on #{@expense.pmt_date.strftime('%y/%m/%d')} recorded" }
          format.json { render json: @expense, status: :created, location: @expense }
        else
          format.html {
            load_selections
            render action: "new"
          }
          format.json { render json: @expense.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /expenses/1
    # PUT /expenses/1.json
    def update
      @expense = Expense.accessible_by(current_ability).find(params[:id])
  
      respond_to do |format|
        if @expense.update_attributes(expense_params)
          format.html { redirect_to reports_path, notice: "#{@expense.amount} expense on #{@expense.pmt_date.strftime('%y/%m/%d')} changed" }
          format.json { head :ok }
        else          
          format.html {
            load_selections
            render action: "edit"
          }
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
        format.html { redirect_to reports_url, notice: "#{@expense.amount} expense on #{@expense.pmt_date.strftime('%y/%m/%d')} removed" }
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
      @expense = Expense.new(expense_params)
      error = false
  #    flash[:error] = nil
      if(params[:expense].amount >= @parent_expense.amount)
        flash[:error] = 'Sub-amount can not exceed parent amount.'
        error = true
      end
      if (params[:expense].payment_type_id != @parent_expense.payment_type_id)
        flash[:error] = 'Sub-expense must have the same payment method as parent expense.'
        error = true
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

  private

    def expense_params
      #do not allow modifying recurring_id from UI
      params.require(:expense).permit(:amount, :pmt_date, :note, :category_id, :payment_type_id, :payee_payer)
    end
  end
end
