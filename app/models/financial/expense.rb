module Financial
  class Expense < Payment
    belongs_to :expense_category, :foreign_key => :category_id
    belongs_to :payment_type
    
    validate :assoc_with_expense_category

    protected
    def assoc_with_expense_category
      if self.expense_category.class != Financial::ExpenseCategory
        errors.add(:expense_category, "is invalid")
      end
    end
  end
end