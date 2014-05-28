class AddRgToDistributors < ActiveRecord::Migration
  def change
    add_column :distributors, :rg, :integer
  end
end
