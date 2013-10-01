require_dependency "financial/application_controller"

module Financial
  class ReportsController < AuthorizableController
    #usecase tabs
    set_tab :daily_tracking, :usecases, :only => %w(index)
    #resource tabs
    set_tab :reports, :daily_resources, :only => %w(index)
    #action tabs
    set_tab :list, :expense, :only => %w(index)

    def index
      prepare_report
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
      @report = Report.new(@date)
    end
  end
end
