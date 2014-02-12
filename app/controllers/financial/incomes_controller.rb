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
      @payments = {'start_date'=>start_date, 'end_date'=>end_date}
      @payments['list'] = Income.accessible_by(current_ability).where(range_condition).order(:pmt_date).to_a
      @payments['total'] = Money.new(Income.accessible_by(current_ability).where(range_condition).sum(:amount_cents))
    end

    def new
      load_selections
      @payment = Income.new(:pmt_date=>Date.today)
    end

    def edit
      load_selections
      @payment = Income.accessible_by(current_ability).find(params[:id])
    end

    def create
      @payment = Income.new(income_params)
      @payment.person = @person
      respond_to do |format|
        if @payment.save
          format.html {
            redirect_to new_income_path,
                        notice: "#{@payment.amount} income on #{@payment.pmt_date.strftime('%y/%m/%d')} recorded"
          }
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

    def update
      @payment = Income.accessible_by(current_ability).find(params[:id])
  
      respond_to do |format|
        if @payment.update_attributes(income_params)
          format.html { redirect_to reports_path, notice: "#{@payment.amount} income on #{@payment.pmt_date.strftime('%y/%m/%d')} changed"}
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

    # DELETE /incomes/1
    # DELETE /incomes/1.json
    def destroy
      @payment = Income.accessible_by(current_ability).find(params[:id])
      @payment.destroy
  
      respond_to do |format|
        format.html { redirect_to reports_url, notice: "#{@payment.amount} income on #{@payment.pmt_date.strftime('%y/%m/%d')} removed" }
        format.json { head :ok }
      end
    end

    protected

    def load_selections
      @categories = IncomeCategory.all
      @payment_types = PaymentType.all
    end

    private

    def income_params
      #do not allow modifying recurring_id from UI
      params.require(:income).permit(:amount, :pmt_date, :note, :category_id, :payment_type_id, :payee_payer)
    end
  end
end
