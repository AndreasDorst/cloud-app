class CreateVms < ActiveRecord::Migration[8.0]
  def change
    create_table :vms do |t|
      t.string :name
      t.integer :cpu
      t.integer :ram
      t.integer :cost

      t.timestamps
    end
  end
end
