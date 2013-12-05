module Financial
  class ExpenseCategory < Category
    has_many :expenses, :foreign_key => :category_id
    has_many :recurring_expenses, :foreign_key => :category_id

    def ExpenseCategory.get_desc(type_id)
      d = ExpenseCategory.select("description").where(:id=>5).first
      if !d.blank?
        return d.description
      else
        return 'unknown'
      end
    end
  end
end