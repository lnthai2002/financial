module Financial
  class Report
    attr_reader :date
    def initialize(date)
      @date = date
      #inclusive search
    end

    def month_summary
      if !@month_summary
        @month_summary = summary_in_range(@date.beginning_of_month, @date.end_of_month)  
      end
      return @month_summary
    end

    def week_summary
      if !@week_summary
        @week_summary = summary_in_range(@date.beginning_of_week, @date.end_of_week)  
      end
      return @week_summary
    end

    def date_summary
      if !@date_summary
        @date_summary={'total_expense'=>Money.new(Expense.sum(:amount_cents, :conditions=>["pmt_date = DATE(?)", @date])),
                     'total_income'=>Money.new(Income.sum(:amount_cents, :conditions=>["pmt_date = DATE(?)", @date]))}
        @date_summary['total_balance']= @date_summary['total_income'] - @date_summary['total_expense']
      end
      return @date_summary
    end

    private

    def summary_in_range(start_date, end_date)
      #inclusive search
      conditions = ["pmt_date BETWEEN DATE(?) AND DATE(?)",
                    start_date.strftime("%Y-%m-%d"),
                    end_date.strftime("%Y-%m-%d")]

      summary = {'start'=>start_date, 'end'=>end_date,
                 'expense'=>Expense.sum(:amount_cents, :conditions=>conditions, :group=>:category_id),
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