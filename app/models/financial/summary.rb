module Financial
  class Summary
    def self.expenses_by_date_range(ability, start_date, end_date)
      return Expense.accessible_by(ability).joins(:expense_category)
                    .select("description, SUM(amount_cents) AS amount_cents")
                    .where(date_range_conditions).group('category_id').all
    end

    def self.incomes_by_date_range(ability, start_date, end_date)
      return Income.accessible_by(ability).joins(:income_category)
                   .select("description, SUM(amount_cents) AS amount_cents")
                   .where(date_range_conditions).group('category_id').all
    end

    def self.by_date_range(ability, start_date, end_date)
      #inclusive search
      summary = {'start'=>start_date, 'end'=>end_date,
                 'expense'=>expenses_by_date_range(ability, start_date, end_date),
                 'income'=>incomes_by_date_range(ability, start_date, end_date)}

      summary['total_expense'] = summary['expense'].inject(Money.new(0)){|total, summ| total + summ.amount}
      summary['total_income'] = summary['income'].inject(Money.new(0)){|total, summ| total + summ.amount}
      summary['total_balance'] = summary['total_income'] - summary['total_expense']

      return summary
    end

    private

    def self.date_range_conditions(start_date, end_date) 
      return ["pmt_date BETWEEN DATE(?) AND DATE(?)",
               start_date.strftime("%Y-%m-%d"),
               end_date.strftime("%Y-%m-%d")]
    end
  end
end
