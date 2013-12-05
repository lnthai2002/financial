require_dependency "financial/application_controller"

module Financial
  class IncomesController < AuthorizableController
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
      @incomes = {'start_date'=>start_date, 'end_date'=>end_date}
      @incomes['list'] = Income.accessible_by(current_ability).where(range_condition).order(:pmt_date).all
      @incomes['total'] = Money.new(Income.accessible_by(current_ability).where(range_condition).sum(:amount_cents))
      
      respond_to do |format|
        format.html # index.html.erb
        format.xml  { render :xml => @expenses }
      end
    end

    def new
      load_selections
      @income = Income.new(:pmt_date=>Date.today)
    end

    def edit
      load_selections
      @income = Income.accessible_by(current_ability).find(params[:id])
    end

    def create
      @income = Income.new(income_params)
      @income.person = @person
      respond_to do |format|
        if @income.save
          format.html {
            redirect_to new_income_path,
                        notice: "#{@income.amount} income on #{@income.pmt_date.strftime('%y/%m/%d')} recorded"
          }
          format.json { render json: @income, status: :created, location: @income }
        else
          format.html {
            load_selections
            render action: "new"
          }
          format.json { render json: @income.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      @income = Income.accessible_by(current_ability).find(params[:id])
  
      respond_to do |format|
        if @income.update_attributes(income_params)
          format.html { redirect_to reports_path, notice: "#{@income.amount} income on #{@income.pmt_date.strftime('%y/%m/%d')} changed"}
          format.json { head :ok }
        else
          format.html {
            load_selections 
            render action: "edit" 
          }
          format.json { render json: @income.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /incomes/1
    # DELETE /incomes/1.json
    def destroy
      @income = Income.accessible_by(current_ability).find(params[:id])
      @income.destroy
  
      respond_to do |format|
        format.html { redirect_to reports_url, notice: "#{@income.amount} income on #{@income.pmt_date.strftime('%y/%m/%d')} removed" }
        format.json { head :ok }
      end
    end

    protected

    def load_selections
      @income_categories = IncomeCategory.all
      @payment_types = PaymentType.all
    end

    private

    def income_params
      #do not allow modifying recurring_id from UI
      params.require(:income).permit(:amount, :pmt_date, :note, :category_id, :payment_type_id, :payee_payer)
    end
  end
end
