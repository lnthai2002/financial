class CreateFinancialPlans < ActiveRecord::Migration
  def change
    create_table :financial_plans do |t|
      t.column :name, :string
      t.column :person_id, :integer
      t.timestamps
    end
  end
end
