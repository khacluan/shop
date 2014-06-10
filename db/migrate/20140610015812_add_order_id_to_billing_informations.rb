class AddOrderIdToBillingInformations < ActiveRecord::Migration
  def change
    add_column :billing_informations, :order_id, :integer
  end
end
