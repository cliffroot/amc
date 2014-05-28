class AddRgToProducts < ActiveRecord::Migration
  def change
    add_column :products, :rg, :string
  end
end
