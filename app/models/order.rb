class Order < ActiveRecord::Base
	belongs_to :cart
	belongs_to :user
  has_one :billing_information, dependent: :destroy

  def total_cost
    cost = 0
    self.cart.line_items.each {|item| cost +=(item.qty * item.product.try(:price))}
    return cost
  end
end
