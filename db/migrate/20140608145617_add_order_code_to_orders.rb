class AddOrderCodeToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :order_code, :string
  end
end
