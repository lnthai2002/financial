module Financial
  class Finance < ActiveRecord::Base
    monetize :net_monthly_income_cents, :numericality=>{:greater_than_or_equal_to=>0}
    monetize :net_monthly_expense_cents, :numericality=>{:greater_than_or_equal_to=>0}

    belongs_to :person

    validates_associated :person
  end
end
