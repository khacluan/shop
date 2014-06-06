class CartSession < ActiveRecord::Base
   #Initalize Cart Session
    def initialize(session)
      @session = session
      @session[:cart] ||= {}
    end

    #Cart Count
    def cart_count
      if (@session[:cart][:products] && @session[:cart][:products] != {})
          @session[:cart][:products].count
      else
          0
      end
    end

    #Cart Contents
    def cart_contents
      products = @session[:cart][:products]

      if (products && products != {})

          #Determine Quantities
          quantities = Hash[products.uniq.map {|i| [i, products.count(i)]}]

          #Get products from DB
          products_array = Product.find(products.uniq)

          #Create Qty Array
          products_new = {}
          products_array.each{
              |a| products_new[a] = {"qty" => quantities[a.id.to_s]}
          }

          #Output appended
          return products_new

      end

    end

    #Qty & Price Count
    def subtotal
      products = cart_contents

      #Get subtotal of the cart items
      subtotal = 0
      unless products.blank?
          products.each do |a|
              subtotal += (a[0]["price"].to_f * a[1]["qty"].to_f)
          end
      end

      return subtotal

    end

    #Build Hash For ActiveMerchant
    def build_order

      #Take cart objects & add them to items hash
      products = cart_contents

      @order = []
      products.each do |product|
          @order << {name: product[0].name, quantity: product[1]["qty"], amount: (product[0].price * 100).to_i }
      end

      return @order
    end

    #Build JSON Requests
    def build_json
      session = @session[:cart][:products]
      json = {:subtotal => self.subtotal.to_f.round(2), :qty => self.cart_count, :items => Hash[session.uniq.map {|i| [i, session.count(i)]}]}
      return json
    end
end
