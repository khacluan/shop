class BillingInformation < ActiveRecord::Base
	belongs_to :user
	validates :first_name, :last_name, :address, :zip_code, :city, :state, :tel, presence: true	
end
