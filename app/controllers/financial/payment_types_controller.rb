require_dependency "financial/application_controller"

module Financial
  class PaymentTypesController < ApplicationController
    # GET /payment_types
    # GET /payment_types.json
    def index
      @payment_types = PaymentType.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @payment_types }
      end
    end

    # GET /payment_types/new
    # GET /payment_types/new.json
    def new
      @payment_type = PaymentType.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @payment_type }
      end
    end
  
    # GET /payment_types/1/edit
    def edit
      @payment_type = PaymentType.find(params[:id])
    end
  
    # POST /payment_types
    # POST /payment_types.json
    def create
      @payment_type = PaymentType.new(payment_type_params)
  
      respond_to do |format|
        if @payment_type.save
          format.html { redirect_to payment_types_path, notice: "'#{@payment_type.description}' added" }
          format.json { render json: @payment_type, status: :created, location: @payment_type }
        else
          format.html { render action: "new" }
          format.json { render json: @payment_type.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /payment_types/1
    # PUT /payment_types/1.json
    def update
      @payment_type = PaymentType.find(params[:id])
      old_desc = @payment_type.description
      respond_to do |format|
        if @payment_type.update_attributes(payment_type_params)
          format.html { redirect_to payment_types_path, notice: "#{old_desc} changed to #{@payment_type.description}" }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @payment_type.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /payment_types/1
    # DELETE /payment_types/1.json
    def destroy
      @payment_type = PaymentType.find(params[:id])
      respond_to do |format|
        if @payment_type.payments.exists? || @payment_type.recurring_payments.exists?
          format.html { redirect_to payment_types_url, alert: "#{@payment_type.description} is used in multiple payments, cant delete!" }
          format.json { render json: @payment_type.errors, status: :unprocessable_entity }
        else
          @payment_type.destroy
          format.html { redirect_to payment_types_url, notice: "#{@payment_type.description} removed" }
          format.json { head :ok }
        end
      end
    end

    private

    def payment_type_params
      params.require(:payment_type).permit(:description)
    end
  end
end