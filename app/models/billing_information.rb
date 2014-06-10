class BillingInformation < ActiveRecord::Base
	belongs_to :user
  belongs_to :order
	validates :first_name, :last_name, :address, :zip_code, :city, :state, :tel, presence: true

  def name
    "#{last_name} #{first_name}"
  end
end
