module Financial
  class ExpenseCategory < Category
    has_many :expenses
    
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