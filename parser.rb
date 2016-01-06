require 'csv'
require "json"

# Run ruby parser.rb in the console to create a parsed_customers text file.

class Parser

  def run!
    parse_customers
    create_parsed_txt
  end

  private

  def parse_customers
    purchases_text = File.read("customers.txt")
    customers_arr = []
    purchases_text.each_line do |customer|
      customer = JSON.parse(customer)
      if valid_distance(customer['latitude'].to_f, customer['longitude'].to_f)
        customers_arr <<  [customer['user_id'], customer['name']]
      end
    end
    @parsed_customers = customers_arr.sort
  end

  def valid_distance(lat, long)
    rad = Math::PI/180
    earth_radius = 6371

    diff_lat = (53.3381985 - lat) * rad
    diff_long = (-6.2592576 - long) * rad
    lat_rad = lat * rad
    olat_rad = 53.3381985 * rad

    a = Math.sin(diff_lat/2)**2 + Math.cos(lat_rad) * Math.cos(olat_rad) * Math.sin(diff_long/2)**2
    c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))
    return true if c * earth_radius < 100
    false
  end

  def create_parsed_txt
    CSV.open("parsed_customers.txt", "w", { :col_sep => ", " }) do |txt|
     @parsed_customers.each do |customer|
      txt << customer
     end
    end
  end
end

parser = Parser.new
parser.run!
