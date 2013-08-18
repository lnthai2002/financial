module Financial
  class RecurringPayment < ActiveRecord::Base
    monetize :amount_cents

    attr_accessible :frequency, :first_date, :last_posted_date, :category_id, :amount, :note, :payment_type_id, :type
  end
end
