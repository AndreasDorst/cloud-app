class CreateProjectVms < ActiveRecord::Migration[8.0]
  def change
    create_table :project_vms do |t|
      t.references :project, null: false, foreign_key: true
      t.references :vm, null: false, foreign_key: true

      t.timestamps
    end
  end
end
