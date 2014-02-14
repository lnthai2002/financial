module Financial
  class IncomesController < AuthorizableController
    before_action :load_selections, only:[:new, :edit]

    # GET /incomes
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

    # GET /incomes/new
    def new
      @payment = Income.new(:pmt_date=>Date.today)
      render 'financial/payments/form'
    end

    # GET /incomes/1/edit
    def edit
      @payment = Income.accessible_by(current_ability).find(params[:id])
      render 'financial/payments/form'
    end

    # POST /incomes
    # POST /incomes.json
    def create
      @payment = Income.new(income_params)
      @payment.person = @person
      respond_to do |format|
        if @payment.save
          flash[:notice] = "#{@payment.amount} income on #{@payment.pmt_date.strftime('%y/%m/%d')} recorded"
          path = incomes_path('start_date'=>@payment.pmt_date.beginning_of_month,
                              'end_date'=>@payment.pmt_date.end_of_month)
          format.html { redirect_to path }
          format.js   { render      'financial/payments/create' }
          format.json { render json: @payment, status: :created, location: @payment }
        else
          format.any(:html, :js) {
            load_selections
            render 'financial/payments/form'
          }
          format.json { render json: @payment.errors, status: :unprocessable_entity }
        end
      end
    end

    def update
      @payment = Income.accessible_by(current_ability).find(params[:id])
  
      respond_to do |format|
        if @payment.update_attributes(income_params)
          flash[:notice] = "#{@payment.amount} income on #{@payment.pmt_date.strftime('%y/%m/%d')} changed"
          path = incomes_path('start_date'=>@payment.pmt_date.beginning_of_month,
                              'end_date'=>@payment.pmt_date.end_of_month)
          format.html { redirect_to path }
          format.js   { render js: %(window.location='#{path}') }
          format.json { head :ok }
        else
          format.any(:html, :js) {
            load_selections
            render 'financial/payments/form'
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

      path = incomes_path('start_date'=>@payment.pmt_date.beginning_of_month,
                           'end_date'=>@payment.pmt_date.end_of_month)

      respond_to do |format|
        format.html { redirect_to path, notice: "#{@payment.amount} income on #{@payment.pmt_date.strftime('%y/%m/%d')} removed" }
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
