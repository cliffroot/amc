class CreateDistributors < ActiveRecord::Migration
  def change
    create_table :distributors do |t|
      t.string :name
      t.string :formula_price
      t.string :formula_del_uae
      t.string :formula_del_eu
      t.integer :column_code
      t.integer :column_price
      t.integer :column_weight
      t.integer :column_amount
      t.integer :column_description
      t.integer :column_koef
      t.integer :column_pg
      t.timestamps
    end
  end
end
