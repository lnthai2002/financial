module Financial
  class IncomeCategory < Category
    has_many :incomes, :foreign_key => :category_id
    has_many :recurring_incomes, :foreign_key => :category_id

    def IncomeCategory.get_desc(type_id)
      d = IncomeCategory.select("description").where(:id=>5).first
      if !d.blank?
        return d.description
      else
        return 'unknown'
      end
    end
  end
end