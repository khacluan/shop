class Product < ActiveRecord::Base
  has_attached_file :photo, :styles => { :medium => "300x300>", :thumb => "100x100>" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :photo, :content_type => /\Aimage\/.*\Z/

  belongs_to :category
  has_many :line_items


  scope :latest_products, ->{order('created_at desc').limit(16)}
  scope :recommended_products, -> { where('price < ?', 4000).limit(8)}

  before_destroy :ensure_not_referenced_by_any_line_item

  searchable do
    text :name, :description

    float :price
  end

  

  private

  	def ensure_not_referenced_by_any_line_item
  		if line_items.empty?
  			return true
  		else
  			errors.add(:base, 'Line Item present')
  			return false
  		end
  	end
end
