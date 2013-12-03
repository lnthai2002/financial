module Financial
  class Plan < ActiveRecord::Base
    before_save :set_values

    has_one :mortgage, :dependent => :destroy
    has_one :investment, :dependent => :destroy
    belongs_to :person

    #it can have more, TODO: make it polymophic association
    accepts_nested_attributes_for :mortgage
    accepts_nested_attributes_for :investment
    
    validates_associated :mortgage
    validates_associated :investment
    validates_associated :person

    def finance
      @fi = person.finance if @fi.blank?
      return @fi
    end

    #amount left after all spending
    def monthly_saving
      return (finance.net_monthly_income - mortgage.net_monthly_payment - finance.net_monthly_expense)
    end

    protected
    #set default friendly name if not provided, sum investment and mortgage down payment
    def set_values
      if self.name.blank?
        self.name = Time.now.to_s
      end
    end
  end
end
