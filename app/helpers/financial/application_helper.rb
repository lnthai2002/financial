module Financial
  module ApplicationHelper
    def months_from_2_years_ago
      date = Date.today
      months = []
      24.times do
        months << [date.strftime("%Y %b"), date.strftime("%Y%m%d")]
        date = date.prev_month
      end
      return months
    end

    def last_12_weeks
      date = Date.today
      weeks = []
      12.times do
        weeks << ["#{date.beginning_of_week.strftime("%Y-%m-%d")} - #{date.end_of_week.strftime("%Y-%m-%d")}", date.beginning_of_week.strftime("%Y%m%d")]
        date = date.prev_week
      end
      return weeks
    end
  end
end
