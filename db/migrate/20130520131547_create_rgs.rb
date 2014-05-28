class CreateRgs < ActiveRecord::Migration
  def change
    create_table :rgs do |t|
      t.string :manufacturer
      t.string :code
      t.float :value

      t.timestamps
    end
  end
end
