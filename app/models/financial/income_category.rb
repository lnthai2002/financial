module Financial
  class IncomeCategory < Category
    has_many :incomes
  end
end