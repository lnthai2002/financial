module Financial
  class Payment < ActiveRecord::Base
    monetize :amount_cents
    
    attr_accessible :amount, :pmt_date, :note, :category_id, :payment_type_id
  end
end
