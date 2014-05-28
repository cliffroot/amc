class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :code
      t.string :price
      t.string :weight
      t.integer :amount
      t.text :description
      t.integer :manufacturer_id
      t.integer :distributor_id
      t.string :route
    end
  end
end