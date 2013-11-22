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
      @income = Income.new
    end

    def edit
      load_selections
      @income = Income.accessible_by(current_ability).find(params[:id])
    end

    def create
      @income = Income.new(params[:income])
      @income.person = @person
      if @income.save
        redirect_to new_income_path
      else
        render action: "new"
      end
    end

    def update
      @income = Income.accessible_by(current_ability).find(params[:id])
  
      respond_to do |format|
        if @income.update_attributes(params[:income])
          format.html { redirect_to reports_path, notice: 'Income was successfully changed.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
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
        format.html { redirect_to reports_url }
        format.json { head :ok }
      end
    end

    private

    def load_selections
      @income_categories = IncomeCategory.all
      @payment_types = PaymentType.all
    end
  end
end
