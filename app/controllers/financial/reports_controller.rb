module Financial
  class ReportsController < AuthorizableController
    def summaries
      prepare_report
    end

    def balance_by_months
      prepare_report
    end

    def monthly_for_categories_form
      @categories = Category.all.sort_by{|cat| cat.description}
      respond_to do |format|
        format.js {render 'monthly_for_categories'}
      end
    end

    def monthly_for_categories
      begin
        @date = Date.parse(params[:date])
      rescue
        @date = Date.today
      end
      
      categories = []
      params[:category].each{|cat,selected| categories << cat if selected == '1'}
      @category_report = CategoryReport.new(@date, categories, current_ability)
    end

    #ajax call to update by_month
    def month_summary
      prepare_report
    end

    #ajax call to update by_week
    def week_summary
      prepare_report
    end

    #ajax call to update by_date
    def date_summary
      prepare_report
    end

    protected

    def prepare_report
      begin
        @date = Date.parse(params[:date])
      rescue
        @date = Date.today
      end
      @report = Report.new(@date, current_ability)
    end
  end
end
