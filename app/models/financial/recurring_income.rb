module Financial
  class RecurringIncome < RecurringPayment
    belongs_to :income_category, :foreign_key => :category_id
    belongs_to :payment_type
  end
end