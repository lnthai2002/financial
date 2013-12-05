module Financial
  class Category < ActiveRecord::Base
    has_many :payments
    has_many :recurring_payments
    validates :description, :type, :presence=>true
  end
end
