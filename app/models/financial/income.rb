module Financial
  class Income < Payment
    belongs_to :income_category, :foreign_key => :category_id
    belongs_to :payment_type

    validate :assoc_with_income_category

    protected
    def assoc_with_income_category
      if self.income_category.class != Financial::IncomeCategory
        errors.add(:income_category, "is invalid")
      end
    end
  end
end
