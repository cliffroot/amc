class CreateManufacturers < ActiveRecord::Migration
  def change
    create_table :manufacturers do |t|
      t.string :name
      t.integer :distributor_id
      t.datetime :last_price_update
    end
  end
end
