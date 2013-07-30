class CreateFinancialCategories < ActiveRecord::Migration
  def change
    create_table :financial_categories do |t|
      t.column :description, :string, :limit=>64
      t.column :type, :string
      t.timestamps
    end
  end
end
