module Financial
  class PaymentType < ActiveRecord::Base
    has_many :expenses
    validates :description, :presence=>true
  end
end