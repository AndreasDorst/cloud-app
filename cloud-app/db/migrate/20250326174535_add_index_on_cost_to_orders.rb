class AddIndexOnCostToOrders < ActiveRecord::Migration[8.0]
  def change
    add_index :orders, :cost
  end
end
