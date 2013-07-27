module Financial
  class Expense < ActiveRecord::Base
    monetize :amount_cents
    belongs_to :exp_type
    belongs_to :payment_type
  end
end