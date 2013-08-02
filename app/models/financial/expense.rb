module Financial
  class Expense < ActiveRecord::Base
    monetize :amount_cents
    belongs_to :expense_category
    belongs_to :payment_type
  end
end