class AddParamsToOrders < ActiveRecord::Migration[8.0]
  def change
    add_column :orders, :options, :json
  end
end
