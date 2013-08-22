class AddRecurringIdToPayment < ActiveRecord::Migration
  def change
    add_column :financial_payments, :recurring_id, :integer
  end
end
