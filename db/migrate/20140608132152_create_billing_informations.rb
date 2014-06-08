class CreateBillingInformations < ActiveRecord::Migration
  def change
    create_table :billing_informations do |t|
      t.integer :user_id
      t.string :address
      t.string :first_name
      t.string :last_name
      t.string :city
      t.string :zip_code
      t.integer :country_id
      t.string :state
      t.string :tel

      t.timestamps
    end
  end
end
