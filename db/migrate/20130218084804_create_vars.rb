class CreateVars < ActiveRecord::Migration
  def change
    create_table :vars do |t|
      t.string :name
      t.float :value

      t.timestamps
    end
  end
end
