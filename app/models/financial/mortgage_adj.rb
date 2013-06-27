module Financial
  class MortgageAdj < ActiveRecord::Base
    #month: selected month
    #amount: extra payment for the selected year
    #interest: new interest rate applied since the selected year
    attr_accessible :month, :amount, :interest, :mortgage_id

    monetize :amount

    belongs_to :mortgage

    validates_associated :mortgage
    validates :month, :presence => true
    validates :amount, :interest, :numericality => true , :allow_blank=>true
    validates :month, :numericality => { :only_integer => true } , :allow_blank=>true
    validate :rate_adj_must_be_on_first_month_of_year

    protected
    
    def rate_adj_must_be_on_first_month_of_year
      if !interest.blank? && month%12 != 1
        errors.add(:month, "should be the first month of the year the interest rate change")
      end 
    end

    def rate
      @r = self.interest/100 if @r.blank?
      return @r
    end
  end
end
