module Financial
  class Expense < Payment
    belongs_to :expense_category, :foreign_key => :category_id
    belongs_to :payment_type
  end
end