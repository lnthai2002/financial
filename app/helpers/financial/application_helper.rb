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
        weeks << ["#{date.beginning_of_week.strftime("%Y-%m-%d")} - #{date.end_of_week.strftime("%Y-%m-%d")}", date_for_select(date.beginning_of_week)]
        date = date.prev_week
      end
      return weeks
    end

    #take the hash and turn it into DataTable json object to be used for google chart
    def json_table_for_google_chart(data)
      table = [['Categories','Amount'].to_json]
      data.each do |summary|
        table << "['#{summary.description}',#{summary.amount.to_d}]"
      end
      return "[#{table.join(',')}]"
    end

    def json_table_for_GC(summaries)
      table = [['Month','Income','Expense','Balance'].to_json]
      data = Hash.new({'Financial::Income'=>BigDecimal.new(0), 'Financial::Expense'=>BigDecimal.new(0)})
      summaries.each do |summary|
        data["#{summary.year}/#{summary.month}"] = data["#{summary.year}/#{summary.month}"].merge({summary.type=>summary.amount.to_d})
      end
      data.each do |month, val|
        table << "['#{month}', #{val['Financial::Income']}, #{val['Financial::Expense']}, #{val['Financial::Income'] - val['Financial::Expense']}]"
      end
      return "[#{table.join(',')}]"
    end
  end
end
