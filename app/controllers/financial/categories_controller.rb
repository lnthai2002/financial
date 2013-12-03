require_dependency "financial/application_controller"

module Financial
  class CategoriesController < ApplicationController
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
      @category = Category.new(category_params)

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
        if @category.update_attributes(category_params)
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

    private

    def category_params
      params.require(:category).permit(:description, :type)
    end
  end
end
