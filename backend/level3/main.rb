# frozen_string_literal: true

require 'json'
require_relative '../models/car'
require_relative '../models/rental'

file = File.read(File.join(__dir__, 'data/input.json'))

data_hash = JSON.parse(file)

cars = data_hash['cars'].map do |car|
  Car.new(id: car['id'], price_per_day: car['price_per_day'], price_per_km: car['price_per_km'])
end

rentals = data_hash['rentals'].map do |rental|
  Rental.new(id: rental['id'], car_id: rental['car_id'], start_date: rental['start_date'],
             end_date: rental['end_date'], distance: rental['distance'])
end

output = { rentals: [] }

rentals.each do |rental|
  price = rental.price(cars)
  commission = price * 0.3
  insurance_fee = (commission / 2).to_i
  assistance_fee = rental.duration * 100
  drivy_fee = (commission - insurance_fee - assistance_fee).to_i
  output[:rentals] << { id: rental.id, price:,
                        commission: { insurance_fee:, assistance_fee:, drivy_fee: } }
end

File.write(File.join(__dir__, 'data/output.json'), JSON.generate(output))
