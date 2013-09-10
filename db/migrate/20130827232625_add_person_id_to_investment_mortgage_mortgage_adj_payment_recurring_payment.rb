class AddPersonIdToInvestmentMortgageMortgageAdjPaymentRecurringPayment < ActiveRecord::Migration
  def change
    add_column :financial_investments, :person_id, :integer
    add_column :financial_mortgages, :person_id, :integer
    add_column :financial_mortgage_adjs, :person_id, :integer
    add_column :financial_payments, :person_id, :integer
    add_column :financial_recurring_payments, :person_id, :integer
  end
end
