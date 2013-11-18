module Financial
  module ApplicationHelper
    #selected value for date should be in a consistent format 
    def date_for_select(date)
      return date.strftime("%Y%m%d")
    end

    def months_from_2_years_ago
      date = Date.today
      months = []
      24.times do
        months << [date.strftime("%Y %b"), date_for_select(date)]
        date = date.prev_month
      end
      return months
    end

    def last_12_weeks
      date = Date.today
      weeks = []
      12.times do
        weeks << ["#{date.beginning_of_week.strftime("%Y/%m/%d")} - #{date.end_of_week.strftime("%Y/%m/%d")}", date_for_select(date.beginning_of_week)]
        date = date.prev_week
      end
      return weeks
    end

    #take the hash and turn it into DataTable json object to be used for google chart
    def gc_table_for_summary(data)
      table = ["['Categories','Amount']"]
      data.each do |summary|
        table << "['#{summary.description}',#{summary.amount.to_d}]"
      end
      return "[#{table.join(',')}]"
    end

    def gc_table_for_monthly_balance(summaries)
      table = ["['Month','Income','Expense','Balance']"]
      summaries.each do |month, val|
        table << "['#{month}', #{val['Financial::Income']}, #{val['Financial::Expense']}, #{val['Balance']}]"
      end
      return "[#{table.join(',')}]"
    end

    def gc_table_for_category(summary)
      table = ["['Month','Amount']"]
      summary.each do |month, amount|
        table << "['#{month}', #{amount}]"
      end
      return "[#{table.join(',')}]"
    end

    def plan_header(plan)
      return raw plan.name +
      " >>> " +
      link_to('Amortization', plan) +
      " | " +
      link_to('Delete', plan, confirm: 'Are you sure?',
              method: :delete, :remote=>true)
    end
  end
end