class CreatePassportData < ActiveRecord::Migration[8.0]
  def change
    create_table :passport_data do |t|
      t.integer :series
      t.integer :number
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
