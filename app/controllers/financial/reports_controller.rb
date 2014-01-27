require_dependency "financial/application_controller"

module Financial
  class ReportsController < AuthorizableController
    def index
      prepare_report
    end

    def by_category
      @categories = Category.all
    end

    def for_category
      if params[:category]
        begin
          @date = Date.parse(params[:date])
        rescue
          @date = Date.today
        end
        
        categories = []
        params[:category].each{|cat,selected| categories << cat if selected == '1'}
        @category_report = CategoryReport.new(@date, categories, current_ability)
      else
        redirect_to reports_path
      end
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
