require_dependency "financial/application_controller"

module Financial
  class ExpTypesController < ApplicationController
    #usecase tabs
    set_tab :daily_tracking, :usecases, :only => %w(index show new edit)
    #resource tabs
    set_tab :expense_types, :daily_resources, :only => %w(index show new edit)
    #action tabs
    set_tab :list, :expense_type, :only => %w(index)
    set_tab :show, :expense_type, :only => %w(show)
    set_tab :add, :expense_type, :only => %w(new)
    set_tab :edit, :expense_type, :only => %w(edit)

    # GET /exp_types
    # GET /exp_types.json
    def index
      @exp_types = ExpType.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @exp_types }
      end
    end
  
    # GET /exp_types/new
    # GET /exp_types/new.json
    def new
      @exp_type = ExpType.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @exp_type }
      end
    end
  
    # GET /exp_types/1/edit
    def edit
      @exp_type = ExpType.find(params[:id])
    end
  
    # POST /exp_types
    # POST /exp_types.json
    def create
      @exp_type = ExpType.new(params[:exp_type])
  
      respond_to do |format|
        if @exp_type.save
          format.html { redirect_to exp_types_path, notice: 'Category was successfully added.' }
          format.json { render json: @exp_type, status: :created, location: @exp_type }
        else
          format.html { render action: "new" }
          format.json { render json: @exp_type.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /exp_types/1
    # PUT /exp_types/1.json
    def update
      @exp_type = ExpType.find(params[:id])
  
      respond_to do |format|
        if @exp_type.update_attributes(params[:exp_type])
          format.html { redirect_to exp_types_path, notice: 'Category was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @exp_type.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /exp_types/1
    # DELETE /exp_types/1.json
    def destroy
      @exp_type = ExpType.find(params[:id])
      @exp_type.destroy
  
      respond_to do |format|
        format.html { redirect_to exp_types_url }
        format.json { head :ok }
      end
    end
  end
end