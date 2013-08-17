class CreateFinancialRecurringPayments < ActiveRecord::Migration
  def change
    create_table :financial_recurring_payments do |t|
      t.column :frequency, :string
      t.column :first_date , :date
      t.column :last_posted_date, :date
      t.column :category_id, :integer
      t.money :amount
      t.column :note, :string, :limit=>300
      t.column :payment_type_id, :integer
      t.column :type, :string
      t.timestamps
    end
  end
end
