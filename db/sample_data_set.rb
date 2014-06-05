class SampleDataSet < ActiveRecord::Base
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

  def self.load_categories(url)
    json_array = parse(url)
    json_array['ResultSet']['0']['Result']['Categories']['Children'].map do |key, value|
      if value && value['Id']
        # puts "id is : #{value['Id']} --- name: #{value['Title']['Short']}"
        Category.create(id: value['Id'], name: value['Title']['Short']) if !Category.find_by(id: value['Id'])
      end
    end
  end
end