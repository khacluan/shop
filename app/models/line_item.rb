class LineItem < ActiveRecord::Base
  belongs_to :product
  belongs_to :cart

  def amount
    self.product.price * self.qty
  end
end
