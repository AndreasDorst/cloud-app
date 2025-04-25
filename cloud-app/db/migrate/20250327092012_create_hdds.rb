class CreateHdds < ActiveRecord::Migration[8.0]
  def change
    create_table :hdds do |t|
      t.string :hdd_type
      t.integer :size

      t.timestamps
    end
  end
end
