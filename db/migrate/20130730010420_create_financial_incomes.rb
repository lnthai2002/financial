class CreateFinancialIncomes < ActiveRecord::Migration
  def change
    create_table :financial_incomes do |t|
      t.column :inc_date , :date
      t.column :income_category_id, :integer
      t.money :amount
      t.column :note, :string, :limit=>300
      t.column :payment_type_id, :integer
      t.timestamps
    end
  end
end
