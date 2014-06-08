class Cart < ActiveRecord::Base
	has_many :line_items, dependent: :destroy
	
	def self.item_count(cart_id)
		cart = Cart.where(id: cart_id).includes(:line_items).first
		if cart
			cart.line_items.count
		else
			0
		end
	end

	def total_cost
		total = 0
		self.line_items.each do |item|
			total += (item.qty * item.product.try(:price))
		end
		return total
	end

end
