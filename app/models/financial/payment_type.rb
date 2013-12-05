module Financial
  class PaymentType < ActiveRecord::Base
    has_many :payments
    has_many :recurring_payments
    validates :description, presence: true, uniqueness: true
  end
end