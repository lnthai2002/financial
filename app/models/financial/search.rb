module Financial
  class Search
    def initialize(params)
      @params = params
    end

    def execute
      if %w{Expense, Income, Payment}.include?(@params['type'])
        search_payments
      end
    end

    private

    def search_payments
      conditions = Payment
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
        conditions = conditions.where("payee_payer LIKE %?%", @params['payee_payer'])
      end
      if not @params['note'].blank?
        conditions = conditions.where("note LIKE %?%", @params['note'])
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
      end
    end
  end
end