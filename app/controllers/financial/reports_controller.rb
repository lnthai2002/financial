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
      begin
        @date = Date.parse(params[:date])
      rescue
        @date = Date.today
      end
      #inclusive search
      @month_summary = summary_in_range(@date.beginning_of_month, @date.end_of_month)
      @week_summary = summary_in_range(@date.beginning_of_week, @date.end_of_week)
    end

    private

    def summary_in_range(start_date, end_date)
      #inclusive search
      conditions = ["pmt_date BETWEEN DATE(?) AND DATE(?)",
                    start_date.strftime("%Y-%m-%d"),
                    end_date.strftime("%Y-%m-%d")]

      summary = {'expense'=>Expense.sum(:amount_cents, :conditions=>conditions, :group=>:category_id),
                 'income'=>Income.sum(:amount_cents, :conditions=>conditions, :group=>:category_id)}

      summary['total_expense'] = Money.new(0)
      summary['expense'].each do |category_id, amount|
        summary['expense'][category_id] = Money.new(amount)
        summary['total_expense'] = summary['total_expense'] + summary['expense'][category_id]
      end

      summary['total_income'] = Money.new(0)
      summary['income'].each do |category_id, amount|
        summary['income'][category_id] = Money.new(amount)
        summary['total_income'] = summary['total_income'] + summary['income'][category_id]
      end
      summary['total_balance'] = summary['total_income'] - summary['total_expense']

      return summary
    end
  end
end
