module Financial
  class ReportsController < AuthorizableController
    def summaries
      prepare_report
    end

    def balance_by_months
      prepare_report

      excluded_categories = []
      params[:category].each{|cat,selected| excluded_categories << cat if selected == '1'}
      if not excluded_categories.blank?
        begin
          @date = Date.parse(params[:date])
        rescue
          @date = Date.today
        end
        @category_report = CategoryReport.new(@date, excluded_categories, current_ability)
      end

    end

    def exclude_from_balance_by_months
      @categories = Category.all.sort_by{|cat| cat.description}
      respond_to do |format|
        format.js {render 'exclude_from_balance_by_months'}
      end
    end

    def monthly_for_categories_form
      @categories = Category.all.sort_by{|cat| cat.description}
      respond_to do |format|
        format.js {render 'monthly_for_categories'}
      end
    end

    def monthly_for_categories
      categories = []
      params[:category].each{|cat,selected| categories << cat if selected == '1'}
      if not categories.blank?
        begin
          @date = Date.parse(params[:date])
        rescue
          @date = Date.today
        end
        @category_report = CategoryReport.new(@date, categories, current_ability)
      else
        redirect_to reports_path, alert: 'No categories selected'
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
