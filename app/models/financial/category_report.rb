module Financial
  class CategoryReport
    attr_reader :date
    attr_reader :category

    def initialize(date, category, current_ability)
      if date
        @date = date
      else
        raise Exception.new("Cannot instantiate report without a date")
      end

      @category = Category.where(:description=>category).first
      if !@category
        raise Exception.new("Cannot instantiate report without a category")
      end

      if current_ability
        @current_ability = current_ability
      else
        raise Exception.new("Can not instantiate report without ability, this violate security")
      end
    end

    def category_by_month
      if !@category_by_month
        @category_by_month = Hash.new(BigDecimal.new(0))
        summary_by_month = Expense.accessible_by(@current_ability)
                                  .select("YEAR(pmt_date) AS year,
                                           MONTH(pmt_date) AS month,
                                           SUM(amount_cents) AS amount_cents")
                                  .where(:category_id=>@category.id)
                                  .group("YEAR(pmt_date), MONTH(pmt_date)")
        summary_by_month.each do |summary|
          @category_by_month["#{summary.year}/#{summary.month}"] = @category_by_month["#{summary.year}/#{summary.month}"].merge({"#{summary.year}/#{summary.month}"=>summary.amount.to_d})
        end
      end
      return @category_by_month
    end

    def month_summary
      if !@month_summary
        @month_summary = Expense.accessible_by(@current_ability)
                                .where(date_range_conditions(@date.beginning_of_month, @date.end_of_month))
                                .where(:category_id=>@category.id)
                                .sum(:amount_cents)
      end
      return @month_summary
    end

    def week_summary
      if !@week_summary
        @week_summary = Expense.accessible_by(@current_ability)
                                .where(date_range_conditions(@date.beginning_of_week, @date.end_of_week))
                                .where(:category_id=>@category.id)
                                .sum(:amount_cents)  
      end
      return @week_summary
    end

    def date_summary
      if !@date_summary
        @date_summary= Expense.accessible_by(@current_ability)
                                .where(["pmt_date = DATE(?)", @date])
                                .where(:category_id=>@category.id)
                                .sum(:amount_cents)
      end
      return @date_summary
    end

    protected

    def date_range_conditions(start_date, end_date) 
      return ["pmt_date BETWEEN DATE(?) AND DATE(?)",
               start_date.strftime("%Y-%m-%d"),
               end_date.strftime("%Y-%m-%d")]
    end
  end
end
