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
      rows = []
      data.each do |summary|
        rows << "['#{summary.description}',#{summary.amount.to_s}]"
      end
      return rows.join(',')
    end
  end
end
