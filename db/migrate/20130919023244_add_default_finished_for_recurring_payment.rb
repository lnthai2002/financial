class AddDefaultFinishedForRecurringPayment < ActiveRecord::Migration
  def up
    change_column_default(:financial_recurring_payments, :finished , false)
  end

  def down
    #set to false in both up and down on purpose because setting to NULL doesn't work
    change_column_default(:financial_recurring_payments, :finished , false)
  end
end
