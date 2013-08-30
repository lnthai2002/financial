module Financial
  class Payment < ActiveRecord::Base
    monetize :amount_cents
    
    attr_accessible :amount, :pmt_date, :note, :category_id, :payment_type_id, :recurring_id, :person_id

    belongs_to :person
    belongs_to :recurring_payment, :foreign_key => :recurring_id

    validate :not_belong_to_recurring_event_when_update, on: :update
    validate :not_belong_to_recurring_event_when_edit, on: :destroy

    def self.from_recurring_payment(recurring)
      new_payment = Payment.new(:category_id=>recurring.category_id,
                                :amount=>recurring.amount, :note=>recurring.note,
                                :payment_type_id=>recurring.payment_type_id,
                                :person_id=>recurring.person_id)
      if recurring.class == Financial::RecurringExpense
        new_payment.type = "Financial::Expense"
      elsif recurring.class == Financial::RecurringIncome
        new_payment.type = "Financial::Income"
      else
        new_payment = nil
      end
      return new_payment
    end

    protected

    def not_belong_to_recurring_event_when_update
      if self.pmt_date_changed? && !self.recurring_payment.blank? #changing posting date of a recurring payment
        errors[:base] << "This payment came from a recurring event, you cannot change its posting date."
      end
    end

    def not_belong_to_recurring_event_when_edit
      #check if this is when user try to destroy recurring event
      if !self.recurring_payment.blank?
        errors[:base] << "This payment came from a recurring event, you can not remove it"
      end
    end
  end
end
