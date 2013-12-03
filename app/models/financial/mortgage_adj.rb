module Financial
  class MortgageAdj < ActiveRecord::Base
    monetize :amount_cents, :numericality=>{:greater_than_or_equal_to=>0}

    #month: selected month
    #amount: extra payment for the selected year
    #interest: new interest rate applied since the selected year

    belongs_to :mortgage
    belongs_to :person

    validates_associated :mortgage
    validates :month, :presence => true
    validates :interest, :numericality => true , :allow_blank=>true
    validates :month, :numericality => { :only_integer => true }
    validates :duration, :numericality => { :only_integer => true } , :allow_blank=>true
    validate :rate_adj_must_be_on_first_month_of_year

    protected
    
    def rate_adj_must_be_on_first_month_of_year
      if !interest.blank? && month%12 != 1
        errors.add(:month, ":interest rate should be changed on the first month of the year")
      end 
    end

    def rate
      @r = self.interest/100 if @r.blank?
      return @r
    end
  end
end
