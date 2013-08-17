class DeleteExpenseAndIncome < ActiveRecord::Migration
  def up
    drop_table :financial_incomes
    drop_table :financial_expenses
  end

  def down
    create_table :financial_expenses do |t|
      t.column :exp_date , :date
      t.column :exp_category_id, :integer
      t.money :amount
      t.column :note, :string, :limit=>300
      t.column :payment_type_id, :integer
      t.timestamps
    end
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
