module Financial
  class Amortization
    #interest_rate is already in float, not percentage
    #loan term in year
    attr_accessor :loan, :interest_rate, :loan_term, :adjustments, :person_id

    def initialize(loan, interest_rate, loan_term, adjustments)
      @loan = loan
      @interest_rate = interest_rate
      @loan_term = loan_term
      @adjustments = adjustments
    end

    def monthly_payment
      @mmp = (loan * monthly_interest_rate / (1-(1+monthly_interest_rate)**(loan_term*(-12)))) if @mmp.blank?
      return @mmp
    end
    
    #TODO: take into account interest rate change
    def start(start_month)
      amo = []
      current_month = 1
      loan_duration = loan_term * 12  #in months
      prev_balance = loan

      while current_month <= loan_duration   #calculate for each month
        global_month = start_month + current_month - 1 #month count from purchase time

        current_interest= (prev_balance * interest_rate)/12
        capital_deduction= monthly_payment - current_interest
        extra_payment = adjustments[global_month]
        extra_payment = extra_payment != nil ? extra_payment.amount : Money.new(0)
        current_balance = prev_balance - capital_deduction - extra_payment
        amo << {:month=>global_month, :interest=>current_interest,
                :cap_deduction=>capital_deduction, :balance=>current_balance,
                :xtra_payment=>extra_payment, :new_rate=>adjustments[global_month].try(:interest),
                :adj_id=>adjustments[global_month].try(:id)}

        if current_balance <= 0
          break
        end

        current_month = current_month + 1
        prev_balance = current_balance

        new_rate = adjustments[global_month+1].try(:interest)
        years_left = adjustments[global_month+1].try(:duration)
        if new_rate != nil || years_left != nil #interest rate changed, make a new mortgage with the loan is the previous balance, and the term is whatever years left from this current mortgage
          if new_rate == nil
            new_rate = interest_rate * 100 #use the current rate, but is is currently float, so need to bring it back to percentage
          end
          if years_left == nil #user did not want to change the length of the mortage
            years_left = (loan_duration - current_month + 1)/12 #rate adjustment happen at the first month of the year, so the number of year left should include the current year
          end
          current_mortgage = Amortization.new(prev_balance, new_rate/100, years_left, adjustments)
          amo += current_mortgage.start(global_month+1)
          return amo
        end
      end
      return amo
    end

    private
    
    def monthly_interest_rate
      interest_rate/12
    end
  end

  class Mortgage < ActiveRecord::Base
    monetize :purchased_price_cents 
    monetize :down_payment_cents
    monetize :municipal_tax_cents
    monetize :school_tax_cents
    monetize :heating_cents
    monetize :house_insurance_cents
    monetize :mortgage_insurance_cents
    monetize :revenue_cents

    #loan_term count by year
    #all tax and insurance are year amount
    #revenue: amount gain by renting part of the building, count by year

    belongs_to :plan
    belongs_to :person
    has_many :mortgage_adjs, :dependent => :destroy

    validates :interest, :numericality => true
    validates :loan_term, :numericality => { :only_integer => true } 

    def monthly_mortgage_payment
      @mmp = (loan * monthly_interest / (1-(1+monthly_interest)**(loan_term*(-12)))) if @mmp.blank?
      return @mmp
    end

    #total amount need to be paid to bank + municipal + school tax + heating + house insurance for whole building
    #TODO: not yet apply mortgage insurance, assuming we always down payment > 20% to avoid mortgage insurance 
    def monthly_payment
      return monthly_mortgage_payment + (municipal_tax + school_tax + heating + house_insurance)/12
    end

    #amount need to pay after revenue deduction
    def net_monthly_payment
      return (monthly_payment - revenue/12)
    end

    def loan_balance_after(year)
      elapse_year = year #ridiculous but make it clear for dummy
      year_left = loan_term - elapse_year
      return (monthly_mortgage_payment * (1- (1+monthly_interest)**(year_left*(-12))) / monthly_interest)
    end

    def total_payment_after(year)
      elapse_year = year #ridiculous but make it clear for dummy
      return (monthly_mortgage_payment * elapse_year * 12)
    end

    def payoff_amount_after(year)
      elapse_year = year #ridiculous but make it clear for dummy
      loan = purchased_price - down_payment #TODO: refactor
      return loan - loan_balance_after(elapse_year)
    end

    def total_interest_after(year)
      elapse_year = year #ridiculous but make it clear for dummy
      return total_payment_after(elapse_year) - payoff_amount_after(elapse_year)
    end

    def total_cost_after(year)
      elapse_year = year #ridiculous but make it clear for dummy
      return down_payment + total_payment_after(elapse_year) + loan_balance_after(elapse_year)
    end

    def amortization
      amo = [{:month=>0, :interest=>0, :balance=>loan, :xtra_payment=>0, :new_rate=>nil, :adj_id=>nil}] #before any payment, we only have 100% loan
      mortgage = Amortization.new(loan, in_rate, loan_term, cached_adjustments)
      return mortgage.start(1)
    end

    #return the amount of extra payment for the selected year, zero if no extra payment made on tha year
    def extra_payment_for(month)
      return cached_adjustments[month].try(:amount).to_f
    end

  protected
    def current_monthly_mortgage_payment(month)
      new_rate = nil
      #find the adjustment before this month which has the interest rate changed
      #TODO: this is a very bad performance, use the cached_adjustments if possible
      #new_rate = self.mortgage_adjs.where("interest IS NOT NULL").where("month >= ?", month).order(:month).first.try(:interest)
      if new_rate.nil?
        return monthly_mortgage_payment
      else
        #TODO: recalculate monthly mortgage payment for the rest of the loan period with the new interest rate  
      end      
    end
    #return a hash of adjustment for this mortgage, with key is the month
    def cached_adjustments
      if @adjs.nil?
        @adjs = {}
        self.mortgage_adjs.to_a.each do |adj|
          @adjs[adj.month]=adj
        end
      end
      return @adjs
    end

    def loan
      @l = (purchased_price - down_payment) if @l.blank?
      return @l
    end

    def in_rate
      @interest_rate = self.interest/100 if @interest_rate == nil
      return @interest_rate
    end
    #no compound on monthly interest
    def monthly_interest
      @m_interest = in_rate/12 if @m_interest == nil
      return @m_interest
    end
  end
end
