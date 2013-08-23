module Financial
  class Payment < ActiveRecord::Base
    monetize :amount_cents
    
    attr_accessible :amount, :pmt_date, :note, :category_id, :payment_type_id, :recurring_id

    belongs_to :recurring_payment, :foreign_key => :recurring_id

    def self.from_recurring_payment(recurring)
      new_payment = Payment.new(:category_id=>recurring.category_id,
                                :amount=>recurring.amount, :note=>recurring.note,
                                :payment_type_id=>recurring.payment_type_id)
      if recurring.class == Financial::RecurringExpense
        new_payment.type = "Financial::Expense"
      elsif recurring.class == Financial::RecurringIncome
        new_payment.type = "Financial::Income"
      else
        new_payment = nil
      end
      return new_payment
    end
  end
end
