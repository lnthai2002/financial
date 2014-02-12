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
      @payments = {'start_date'=>start_date, 'end_date'=>end_date}
      @payments['list'] = Expense.accessible_by(current_ability).where(range_condition).order(:pmt_date).to_a
      @payments['total'] = Money.new(Expense.accessible_by(current_ability).where(range_condition).sum(:amount_cents))
      @payments['summary'] = Summary.expenses_by_categories_in_date_range(current_ability, start_date, end_date)
    end
  
    # GET /expenses/new
    # GET /expenses/new.json
    def new
      load_selections
      @payment = Expense.new(:pmt_date=>Date.today)
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @payment }
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
      @payment = Expense.accessible_by(current_ability).find(params[:id])
    end
  
    # POST /expenses
    # POST /expenses.json
    def create
      @payment = Expense.new(expense_params)
      @payment.person = @person
      respond_to do |format|
        if @payment.save
          format.html { redirect_to new_expense_path, notice: "#{@payment.amount} expense on #{@payment.pmt_date.strftime('%y/%m/%d')} recorded" }
          format.json { render json: @payment, status: :created, location: @payment }
        else
          format.html {
            load_selections
            render action: 'new'
          }
          format.json { render json: @payment.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /expenses/1
    # PUT /expenses/1.json
    def update
      @payment = Expense.accessible_by(current_ability).find(params[:id])
  
      respond_to do |format|
        if @payment.update_attributes(expense_params)
          format.html { redirect_to reports_path, notice: "#{@payment.amount} expense on #{@payment.pmt_date.strftime('%y/%m/%d')} changed" }
          format.json { head :ok }
        else          
          format.html {
            load_selections
            render action: 'edit'
          }
          format.json { render json: @payment.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /expenses/1
    # DELETE /expenses/1.json
    def destroy
      @payment = Expense.accessible_by(current_ability).find(params[:id])
      @payment.destroy
  
      respond_to do |format|
        format.html { redirect_to reports_url, notice: "#{@payment.amount} expense on #{@payment.pmt_date.strftime('%y/%m/%d')} removed" }
        format.json { head :ok }
      end
    end
    
    # GET /expenses/1/breakdown
    def breakdown
      load_selections
      
      @parent_expense = Expense.accessible_by(current_ability).find(params[:id])
      @payment = Expense.new
    end
    
    # PUT /expenses/1/update_breakdown
    def update_breakdown
      @parent_expense = Expense.accessible_by(current_ability).find(params[:id])
      @payment = Expense.new(expense_params)
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
            @parent_expense.update_attribute(:amount, (@parent_expense.amount - @payment.amount))
            @payment.save
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
      @categories = ExpenseCategory.all
      @payment_types = PaymentType.all
    end

  private

    def expense_params
      #do not allow modifying recurring_id from UI
      params.require(:expense).permit(:amount, :pmt_date, :note, :category_id, :payment_type_id, :payee_payer)
    end
  end
end
