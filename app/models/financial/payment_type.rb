module Financial
  class PaymentType < ActiveRecord::Base
    has_many :expenses
  end
end