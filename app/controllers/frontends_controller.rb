class FrontendsController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'frontend'
  include CurrentCart
  before_action :authenticate_user! , only: [:checkout, :profile]
  before_action :set_cart, only: [:add_to_cart, :show_cart, :checkout, :update_cart, :remove_item, :update_billing_information]
  before_action :set_line_item, only: [:edit_cart, :destroy_cart]

  add_breadcrumb "Home", '/', only: [:index, :products_by_category, :product_detail]


  def search
    # Direct connection
    solr = RSolr.connect :url => 'http://luandk:luandk2014@localhost:8088/solr'
    query = params[:q].empty? ? '*' : params[:q]
    @solr_response = solr.paginate (params[:page] || 1), 20, 'select', :params => {
      :q => "name, description, price:#{query}",
    }

    puts @solr_response['response']['docs'].first
  end

  def index
    @categories = Category.order('name asc')
    @latest_products = Product.latest_products
    @recommended_products = Product.recommended_products
  end

  def products_by_category
    @products = []
    @categories = Category.order('name asc')
    if params[:id].present?
      add_breadcrumb "Products",  products_category_path(params[:id])
      @category = Category.find_by(id: params[:id])
      @products = @category.products.paginate(page: (params[:page] || 1), per_page: 6) if @category
    end
  end

  def product_detail
    if params[:id].present?
      @categories = Category.order('name asc')
      @product = Product.find_by(id: params[:id])
      @category = @product.category
      add_breadcrumb "Products",  products_category_path(@category.try(:id))
      add_breadcrumb "Product Detail", product_detail_path(@product.id)
    end
  end

  def add_to_cart
    if params[:id].present? and session[:cart_id].present?
      product = Product.find_by(id: params[:id])
      # @line_item = @cart.line_items.build(product: product)
      @line_item = @cart.line_items.where(product_id: product.id).first
      if @line_item
        @line_item.qty += 1
        @line_item.save
      else
        @cart.line_items.create(product: product, qty: 1)
      end
    end
    render partial: 'shared/show_cart', locals: {cart: @cart}
  end

  def show_cart
    render partial: 'shared/show_cart', locals: {cart: @cart}, layout: false
  end

  def update_cart
    is_updated = false
    if params[:json].present?
      params[:json].each do |key, value|
        item = LineItem.find_by(id: value['id'])
        is_updated = item.update_attributes(qty: value['qty']) if item
      end
    end
    render text: is_updated, layout: false
  end

  def remove_item
    if params[:id].present?
      line_item = @cart.line_items.find_by(id: params[:id])
      line_item.destroy
    end
    render text: @cart.line_items.count
  end

  def checkout
    @order = @cart.order
    if @order.nil?
      @order = Order.create(cart_id: @cart.id, user_id: current_user.id, order_code: "JS-#{SecureRandom.hex(8).upcase}")
    end
    @billing_information = if current_user.billing_information.nil?
      BillingInformation.create(user_id: current_user.id)
    else
      current_user.billing_information
    end
  end

  def profile

  end

  def update_billing_information
    @billing_information = current_user.billing_information

    if @billing_information
      if @billing_information.update_attributes(permitted_billing_params)
        session.delete(:cart_id)
        puts "@ajaaj #{@cart.inspect} and session is #{session[:cart_id]}"
        render action: :thank_you
      else
        @order = @cart.order
        render action: :checkout
      end
    end
  end

  private

    def permitted_billing_params
      params.require(:billing_information).permit(:first_name, :last_name, :address, :zip_code, :city, :state, :tel)
    end

end
