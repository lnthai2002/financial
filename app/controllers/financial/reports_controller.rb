require_dependency "financial/application_controller"

module Financial
  class ReportsController < AuthorizableController
    def index
      prepare_report
    end

    def for_category
      if params[:category]
        begin
          @date = Date.parse(params[:date])
        rescue
          @date = Date.today
        end
        @category_report = CategoryReport.new(@date, params[:category], current_ability)
      else
        redirect_to :index
      end
    end

    #ajax call to update by_month
    def by_month
      prepare_report
    end

    #ajax call to update by_week
    def by_week
      prepare_report
    end

    #ajax call to update by_date
    def by_date
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
