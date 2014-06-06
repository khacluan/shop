# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

require 'net/http'
require 'json'

def self.parse(url)
  response = Net::HTTP.get_response(URI.parse(url))
  result = JSON.parse(response.body)
  if result.has_key? 'Error'
    raise "web service error"
  end
  return result
end

def self.load_categories
  json_array = parse('http://shopping.yahooapis.jp/ShoppingWebService/V1/json/categorySearch?appid=dj0zaiZpPXpIMzBsMUQyTk55dSZkPVlXazlZWGxzYjNoWU0yVW1jR285TUEtLSZzPWNvbnN1bWVyc2VjcmV0Jng9MzI-&category_id=1')
  json_array['ResultSet']['0']['Result']['Categories']['Children'].map do |key, value|
    if value && value['Id']
      # puts "id is : #{value['Id']} --- name: #{value['Title']['Short']}"
      Category.create(id: value['Id'], name: value['Title']['Short']) if !Category.find_by(id: value['Id'])
    end
  end
end

def self.load_products
  Category.all.each do |category|
    products_array = parse("http://shopping.yahooapis.jp/ShoppingWebService/V1/json/itemSearch?appid=dj0zaiZpPXpIMzBsMUQyTk55dSZkPVlXazlZWGxzYjNoWU0yVW1jR285TUEtLSZzPWNvbnN1bWVyc2VjcmV0Jng9MzI-&category_id=#{category.id}")
    products_array['ResultSet']['0']['Result'].map do |key, value|
      if value && value['Name']
        Product.create(id: value['Id'], photo: URI.parse(value['Image']['Medium']), description: value['Description'], price: value['Price']['_value'], name: value['Name'], category_id: category.id)
      end
    end
  end
end

load_categories
load_products
