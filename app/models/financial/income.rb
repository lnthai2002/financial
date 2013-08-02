module Financial
  class Income < ActiveRecord::Base
    monetize :amount_cents
    
    attr_accessible :amount, :inc_date, :note, :income_category_id, :payment_type_id
    
    belongs_to :income_category
    belongs_to :payment_type
  end
end
