class AddDurationToMortgageAdj < ActiveRecord::Migration
  def change
    add_column :financial_mortgage_adjs, :duration, :integer
  end
end
