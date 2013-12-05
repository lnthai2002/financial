module Financial
  class RecurringIncome < RecurringPayment
    belongs_to :income_category, :foreign_key => :category_id
  end
end