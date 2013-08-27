module Financial
  class Investment < ActiveRecord::Base
    monetize :principal_cents
    monetize :monthly_dep_cents

    attr_accessible :principal, :rate, :monthly_dep, :months, :alt_rate, :alt_monthly_dep, :alt_length, :person_id

    #virtual attributes
    attr_reader :alt_rate, :alt_monthly_dep, :alt_length

    validates :rate, :numericality => true
    validates :months, :numericality => { :only_integer => true }
    validates :alt_rate, :numericality => true, :allow_blank=>true
    validates :alt_length, :numericality => { :only_integer => true }, :allow_blank=>true

    belongs_to :plan
    belongs_to :person

    before_create :set_values

    #cast virtual attributes to avoid validation errors
    def alt_rate=(value)
      @alt_rate = ActiveRecord::ConnectionAdapters::Column.value_to_decimal(value)
    end

    def alt_monthly_dep=(value)
      if !value.is_a?(Money)
        @alt_monthly_dep = Money.new((value.to_f*100).to_i)
      else
        @alt_monthly_dep = value
      end
    end

    def alt_length=(value)
      @alt_length = value.to_i
    end

    def future_value
=begin
      percentage_rate = rate / 100
      yearly_dep = monthly_dep * 12
      
      future_value_of_principal = principal*(1+percentage_rate)**(months/12)
      future_value_of_monthly_dep = yearly_dep*(((1+percentage_rate)**(months/12)) -1)/percentage_rate
      
      return (future_value_of_monthly_dep + future_value_of_principal)
=end
      return future_value_with_given_rate_dep_length(self.rate, self.monthly_dep, self.months)
    end

    def alt_future_value
      if self.alt_rate.blank?
        r = self.rate
      else
        r = self.alt_rate
      end
      if self.alt_monthly_dep.blank?
        d = self.monthly_dep
      else
        d = self.alt_monthly_dep
      end
      if self.alt_length.blank?
        l = self.months
      else
        l = self.alt_length
      end
      return future_value_with_given_rate_dep_length(r, d, l)
    end
    protected
    def future_value_with_given_rate_dep_length(g_rate, g_dep, g_length)
      percentage_rate = g_rate / 100
      yearly_dep = g_dep * 12
      
      future_value_of_principal = principal*(1+percentage_rate)**(g_length/12)
      future_value_of_monthly_dep = yearly_dep*(((1+percentage_rate)**(g_length/12)) -1)/percentage_rate
      
      return (future_value_of_monthly_dep + future_value_of_principal)
    end

    def set_values
      if self.alt_rate.blank?
        self.alt_rate = self.rate
      end
      if self.alt_monthly_dep.blank?
        self.alt_monthly_dep = self.monthly_dep
      end
      if self.alt_length.blank?
        self.alt_length = self.months
      end
    end
  end
end
