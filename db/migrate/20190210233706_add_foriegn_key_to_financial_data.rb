class AddForiegnKeyToFinancialData < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :financial_data, :users
  end
end
