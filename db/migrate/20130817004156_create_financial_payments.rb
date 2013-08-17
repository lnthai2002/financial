class CreateFinancialPayments < ActiveRecord::Migration
  def change
    create_table :financial_payments do |t|
      t.column :pmt_date , :date
      t.column :category_id, :integer
      t.money :amount
      t.column :note, :string, :limit=>300
      t.column :payment_type_id, :integer
      t.column :type, :string
      t.timestamps
    end
  end
end
