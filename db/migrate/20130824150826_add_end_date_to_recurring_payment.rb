class AddEndDateToRecurringPayment < ActiveRecord::Migration
  def change
    add_column :financial_recurring_payments, :end_date , :date
    add_column :financial_recurring_payments, :finished , :boolean
    remove_column :financial_recurring_payments, :last_posted_date
  end
end
