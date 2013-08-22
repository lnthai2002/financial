module Financial
  class RecurringPayment < ActiveRecord::Base
    require 'ice_cube'

    monetize :amount_cents

    attr_accessible :frequency, :first_date, :last_posted_date, :category_id, :amount, :note, :payment_type_id, :type

    has_many :payments

    #Post Expense/Income
    def self.post
      RecurringPayment.all.each do |r|
        schedule = Schedule.new(recurring.first_date)
        case r.frequency
          when 'daily'
            schedule.add_recurrence_rule Rule.daily #every day
            if schedule.occurs_on?(Date.today)
              post_daily(r, Date.today)
            end
          when 'bi-weekly'
            schedule.add_recurrence_rule Rule.weekly.count(2) #every 2 weeks
            if schedule.occurs_on?(Date.today)
              post_biweekly(r, Date.today)
            end          
          when 'monthly'
            schedule.add_recurrence_rule Rule.monthly #every month
            if schedule.occurs_on?(Date.today)
              post_monthly(r, Date.today)
            end
          when 'anually'
        end
      end
    end

    private
    def post_daily(recurring, potential_posting_date)
      if recurring.payments.where(:pmt_date=>potential_posting_date).all.blank? #no payment exist on this date yet
        if recurring.first_date == potential_posting_date #arrive at the starting date
          payment = Payment.from_recurring_payment(recurring)
          payment.pmt_date = expected_posting_date
          return payment.save
        else#just another date scheduled for payment, check and create payment for earlier date if needed
          if post_biweekly(recurring, potential_posting_date.yesterday)#only create payment on this date if previous date has been created successfully
            payment = Payment.from_recurring_payment(recurring)
            payment.pmt_date = expected_posting_date
            return payment.save
          else#fail to create payment for previous pay term
            return false
          end
        end
      else#oops, payment exists, go back
        return true
      end
    end

    def post_biweekly(recurring, potential_posting_date)
      if recurring.payments.where(:pmt_date=>potential_posting_date).all.blank? #no payment exist on this date yet
        if recurring.first_date == potential_posting_date #arrive at the starting date
          payment = Payment.from_recurring_payment(recurring)
          payment.pmt_date = expected_posting_date
          return payment.save
        else#just another date scheduled for payment, check and create payment for earlier date if needed
          if post_biweekly(recurring, potential_posting_date.weeks_ago(2))#only create payment on this date if previous date has been created successfully
            payment = Payment.from_recurring_payment(recurring)
            payment.pmt_date = expected_posting_date
            return payment.save
          else#fail to create payment for previous pay term
            return false
          end
        end
      else#oops, payment exists, go back
        return true
      end
    end

    def post_monthly(recurring, potential_posting_date)
      if recurring.payments.where(:pmt_date=>potential_posting_date).all.blank? #no payment exist on this date yet
        if recurring.first_date == potential_posting_date #arrive at the starting date
          payment = Payment.from_recurring_payment(recurring)
          payment.pmt_date = expected_posting_date
          return payment.save
        else#just another date scheduled for payment, check and create payment for earlier date if needed
          if post_biweekly(recurring, potential_posting_date.months_ago(1))#only create payment on this date if previous date has been created successfully
            payment = Payment.from_recurring_payment(recurring)
            payment.pmt_date = expected_posting_date
            return payment.save
          else#fail to create payment for previous pay term
            return false
          end
        end
      else#oops, payment exists, go back
        return true
      end
    end
  end
end
