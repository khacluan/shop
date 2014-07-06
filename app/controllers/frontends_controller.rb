class FrontendsController < ActionController::Base
  protect_from_forgery with: :exception
  layout 'frontend'
  include CurrentCart
  before_action :authenticate_user! , only: [:checkout, :profile, :order]
  before_action :set_cart, only: [:add_to_cart, :show_cart, :checkout, :update_cart, :remove_item, :update_billing_information]

  add_breadcrumb "Home", '/', only: [:index, :products_by_category, :product_detail]


  def search
    # Direct connection
    solr = RSolr.connect :url => 'http://luandk:luandk2014@localhost:8088/solr'
    query = params[:q].empty? ? '*:*' : "name:#{params[:q]}, description:#{params[:q]}, price:#{params[:q]}"
    @solr_response = solr.paginate (params[:page] || 1), 20, 'select', :params => {
      :q => query ,
    }
  end

  def home
    @latest_products = Product.latest_products
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
    render partial: 'shared/show_cart', locals: {cart: @cart, in_action: params[:in_action]}
  end

  def show_cart
    render partial: 'shared/show_cart', locals: {cart: @cart, in_action: params[:in_action]}, layout: false
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

    @billing_information = BillingInformation.new
  end

  def profile

  end

  def update_billing_information
    @order = @cart.order
    @billing_information = BillingInformation.create(permitted_billing_params)
    @billing_information.user_id = current_user.id
    @billing_information.order_id = @cart.order.id if @order

    if @billing_information.save
      render action: :thank_you
    else
      render action: :checkout
    end
  end

  def finish_shopping
    UserMailer.send_order_information(current_user, params[:order_id]).deliver
    session.delete(:cart_id)
    redirect_to action: :index
  end

  def order
    @orders = current_user.orders
  end

  def update_profile
    current_user.update_attributes(params[:user])
  end

  private

    def permitted_billing_params
      params.require(:billing_information).permit(:first_name, :last_name, :address, :zip_code, :city, :state, :tel)
    end

end
