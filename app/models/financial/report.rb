module Financial
  class Report
    attr_reader :date

    def initialize(date, current_ability)
      if date
        @date = date
      else
        raise Exception.new("Cannot instantiate report without a date")
      end

      if current_ability
        @current_ability = current_ability
      else
        raise Exception.new("Can not instantiate report without ability, this violate security")
      end
    end

    def balance_by_month
      if !@balance_by_month
        @balance_by_month = Hash.new({'Financial::Income'=>BigDecimal.new(0), 'Financial::Expense'=>BigDecimal.new(0), 'Balance'=>BigDecimal(0)})

        summary_by_month = Payment.accessible_by(@current_ability)
                                  .select("YEAR(pmt_date) AS year,
                                           MONTH(pmt_date) AS month,
                                           type,
                                           SUM(amount_cents) AS amount_cents")
                                  .group("YEAR(pmt_date), MONTH(pmt_date), type")
                                  .to_a
        summary_by_month.each do |summary|
          @balance_by_month["#{summary.year}/#{summary.month}"] = @balance_by_month["#{summary.year}/#{summary.month}"].merge({summary.type=>summary.amount.to_d})
        end
        @balance_by_month.each do |month, vals|
          vals['Balance'] = vals['Financial::Income'] - vals['Financial::Expense']
        end
      end
      return @balance_by_month
    end

    def month_summary
      if !@month_summary
        @month_summary = Summary.in_date_range(@current_ability, @date.beginning_of_month, @date.end_of_month)  
      end
      return @month_summary
    end

    def week_summary
      if !@week_summary
        @week_summary = Summary.in_date_range(@current_ability, @date.beginning_of_week, @date.end_of_week)  
      end
      return @week_summary
    end

    def date_summary
      if !@date_summary
        date_condition = ["pmt_date = DATE(?)", @date]
        @date_summary={'date'=>@date,
                       'total_expense'=>Money.new(Expense.accessible_by(@current_ability)
                                                         .where(date_condition)
                                                         .sum(:amount_cents)),
                       'total_income'=>Money.new(Income.accessible_by(@current_ability)
                                                       .where(date_condition)
                                                       .sum(:amount_cents))
                      }
        @date_summary['total_balance']= @date_summary['total_income'] - @date_summary['total_expense']
      end
      return @date_summary
    end
  end
end
