class ChangeExpTypeToExpenseCategory < ActiveRecord::Migration
  def change
    add_column :financial_expenses, :expense_category_id, :integer
    remove_column :financial_expenses, :exp_type_id
  end
end
