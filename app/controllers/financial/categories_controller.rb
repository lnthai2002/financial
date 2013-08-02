require_dependency "financial/application_controller"

module Financial
  class CategoriesController < ApplicationController
    #usecase tabs
    set_tab :daily_tracking, :usecases, :only => %w(index new edit)
    #resource tabs
    set_tab :categories, :daily_resources, :only => %w(index new edit)
    #action tabs
    set_tab :list, :category, :only => %w(index)
    set_tab :add, :category, :only => %w(new)
    set_tab :edit, :category, :only => %w(edit)

    # GET /categories
    # GET /categories.json
    def index
      @categories = Category.all
  
      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @categories }
      end
    end
  
    # GET /categories/new
    # GET /categories/new.json
    def new
      @category = Category.new
  
      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @category }
      end
    end
  
    # GET /categories/1/edit
    def edit
      @category = Category.find(params[:id])
    end
  
    # POST /categories
    # POST /categories.json
    def create
      type = params[:category][:type]
      params[:category].delete(:type)
      case type
        when 'Income'
          @category = IncomeCategory.new(params[:category])
        when 'Expense'
          @category = ExpenseCategory.new(params[:category])
      end
  
      respond_to do |format|
        if @category.save
          format.html { redirect_to categories_path, notice: 'Category was successfully added.' }
          format.json { render json: @category, status: :created, location: @category }
        else
          format.html { render action: "new" }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # PUT /categories/1
    # PUT /categories/1.json
    def update
      @category = Category.find(params[:id])
  
      respond_to do |format|
        if @category.update_attributes(params[:category])
          format.html { redirect_to categories_path, notice: 'Category was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render action: "edit" }
          format.json { render json: @category.errors, status: :unprocessable_entity }
        end
      end
    end
  
    # DELETE /categories/1
    # DELETE /categories/1.json
    def destroy
      @category = Category.find(params[:id])
      @category.destroy
  
      respond_to do |format|
        format.html { redirect_to categories_url }
        format.json { head :ok }
      end
    end
  end
end