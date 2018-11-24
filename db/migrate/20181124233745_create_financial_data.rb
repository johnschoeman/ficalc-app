class CreateFinancialData < ActiveRecord::Migration[5.2]
  def change
    create_table :financial_data do |t|
      t.references :user, index: true, null: false
      t.integer :month, null: false
      t.integer :year, null: false
      t.integer :income, null: false
      t.integer :expenses, null: false
      t.integer :net_worth, null: false

      t.timestamps
    end

    add_index :financial_data, [:user_id, :month, :year], unique: true
  end
end
