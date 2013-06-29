# This migration comes from financial (originally 20130609215620)
class CreateFinancialExpTypes < ActiveRecord::Migration
  def change
    create_table :financial_exp_types do |t|
      t.column :description, :string, :limit=>64
      t.timestamps
    end
  end
end