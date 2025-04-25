class AddNetworkReferencesToOrders < ActiveRecord::Migration[8.0]
  def change
    add_reference :orders, :networks, null: false, foreign_key: true, null: true
  end
end
