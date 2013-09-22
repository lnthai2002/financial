module Financial
  class RecurringPayment < ActiveRecord::Base
    include IceCube

    monetize :amount_cents

    attr_accessible :frequency, :first_date, :category_id, :amount, :note, :payment_type_id, :type, :end_date, :finished, :person_id

    belongs_to :person
    has_many :payments, :foreign_key => :recurring_id

    validate :no_payments_when_update, on: :update

    #Post Expense/Income
    def self.post
      RecurringPayment.where(:finished=>false).all.each do |r|#if recurring payment is marked finished, no need to process them
        schedule = Schedule.new(r.first_date)
        case r.frequency
          when 'Daily'
            schedule.add_recurrence_rule Rule.daily #every day
            if schedule.occurs_on?(Date.today)
              post_routine(r, Date.today){ |potential_posting_date|
                potential_posting_date.yesterday
              }
            end
          when 'Bi-weekly'
            schedule.add_recurrence_rule Rule.weekly(2) #every 2 weeks
            if schedule.occurs_on?(Date.today)
              post_routine(r, Date.today){ |potential_posting_date|
                potential_posting_date.weeks_ago(2)
              }
            end          
          when 'Monthly'
            schedule.add_recurrence_rule Rule.monthly #every month
            if schedule.occurs_on?(Date.today)
              post_routine(r, Date.today){ |potential_posting_date|
                potential_posting_date.months_ago(1)
              }
            end
          when 'Anually'
            schedule.add_recurrence_rule Rule.yearly #every year
            if schedule.occurs_on?(Date.today)
              post_routine(r, Date.today){ |potential_posting_date|
                potential_posting_date.years_ago(1)
              }
            end
        end
      end
    end

    protected

    def no_payments_when_update
      #do not allow update if changing first_date or amount and there are payment posted  
      if (self.first_date_changed? || self.amount_changed?) && self.payments.blank?
        errors[:base] << "You can not change first date or amount when this recurring event already triggered."
      end
    end

    private

    def self.post_routine(recurring, potential_posting_date, &block)
      if recurring.payments.where(:pmt_date=>potential_posting_date).all.blank? #no payment exist on this date yet
        if recurring.first_date == potential_posting_date #arrive at the starting date
          payment = Payment.from_recurring_payment(recurring)
          payment.pmt_date = potential_posting_date
          return payment.save
        else#just another date scheduled for payment, check and create payment for earlier date if needed
          if recurring.end_date.nil? || potential_posting_date <= recurring.end_date
            previous_potential_posting_date = block.call(potential_posting_date) #run the block passed by the caller
            previously_posted_successfully = post_routine(recurring, previous_potential_posting_date, &block)#yield &block #post_routine(recurring, potential_posting_date, &block)
            if previously_posted_successfully#only create payment on this date if previous date has been created successfully
              payment = Payment.from_recurring_payment(recurring)
              payment.pmt_date = potential_posting_date
              return payment.save
            else#fail to create payment for previous pay term
              return false
            end
          else#after end date of the recurring payment
            recurring.finished = true
            return recurring.save
          end
        end
      else#oops, payment exists, go back
        return true
      end
    end
  end
end
