class AddDateColumnToFinancialData < ActiveRecord::Migration[5.2]
  def up
    add_column :financial_data, :date, :date

    FinancialDatum.find_each do |datum|
      datum.date = Date.new(datum.year, FinancialDatum.months[datum.month] + 1)
      datum.save
    end

    change_column_null :financial_data, :date, false

    add_index :financial_data, [:user_id, :date]
  end

  def down
    remove_index :financial_data, [:user_id, :date]

    remove_column :financial_data, :date
  end
end
