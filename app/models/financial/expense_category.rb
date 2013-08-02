module Financial
  class ExpenseCategory < Category
    has_many :expenses
    
    def ExpenseCategory.get_desc(type_id)
      d = find_as_hashes(:first, :select=>:description, :conditions=>{:id=>type_id})
      if !d.blank?
        return d[0]['description']
      else
        return 'unknown'
      end
    end
  end
end