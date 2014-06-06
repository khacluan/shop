class FrontendsController < ActionController::Base
  layout 'frontend'

  def index
    @categories = Category.order('name asc')
    @latest_products = Product.latest_products
    @recommended_products = Product.recommended_products
  end

  def products_by_category
    @products = []
    @categories = Category.order('name asc')
    if params[:id].present?
      @category = Category.find_by(id: params[:id])
      @products = @category.products.page(params[:page] || 1).per(6) if @category
    end
  end

  def product_detail
    if params[:id].present?
      @categories = Category.order('name asc')
      @product = Product.find_by(id: params[:id])
    end
  end


end
