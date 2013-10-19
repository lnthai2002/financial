class AddPayeePayerToPayment < ActiveRecord::Migration
  def change
    add_colum :financial_payments, :payee_payer, :string, :limit=>50
  end
end
