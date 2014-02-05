module Financial
  class Search
    def initialize(params, current_ability)
      @params = params
      if current_ability
        @current_ability = current_ability
      else
        raise Exception.new("Can not instantiate search without ability, this violate security")
      end
    end

    def execute
      if %w{Expense Income Payment}.include?(@params['type'])
        search_payments
      end
    end

    private

    def search_payments
      payments = Payment.arel_table
      conditions = Payment.accessible_by(@current_ability)
      if not @params['category_id'].blank?
        conditions = conditions.where(category_id: @params['category_id'])
      end
      if not @params['amount'].blank?
        conditions = conditions.where(amount_cents: (@params['amount'].to_i * 100))
      end
      if not @params['payment_type_id'].blank?
        conditions = conditions.where(payment_type_id: @params['payment_type_id'])
      end
      if not @params['payee_payer'].blank?
        conditions = conditions.where(payments[:payee_payer].matches("%#{@params['payee_payer']}%"))
      end
      if not @params['note'].blank?
        conditions = conditions.where(payments[:note].matches("%#{@params['note']}%"))
      end
      case @params['type']
        when 'Expense'
          conditions = conditions.where(type: 'Financial::Expense')
          return conditions = conditions.all
        when 'Income'
          conditions = conditions.where(type: 'Financial::Income')
          return conditions = conditions.all
        when 'Payment'
          return conditions.all
        else
          return []
      end
    end
  end
end