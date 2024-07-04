# frozen_string_literal: true

require 'json'
require_relative 'car'
require_relative 'rental'
require_relative 'feature'
require_relative 'option'
require_relative 'commission'

class DataProcessor
  def initialize(input_file, output_file)
    @input_file = input_file
    @output_file = output_file
  end

  def process
    data_hash = JSON.parse(File.read(@input_file))

    cars = load_cars(data_hash['cars'])
    rentals = load_rentals(data_hash['rentals'])
    options = load_options(data_hash['options'])

    rental_options = associate_options_to_rentals(rentals, options)
    output = calculate_rental_prices(rentals, cars, rental_options)

    File.write(@output_file, JSON.generate(output))
  end

  private

  def load_cars(car_data)
    car_data.map do |car|
      Car.new(id: car['id'], price_per_day: car['price_per_day'], price_per_km: car['price_per_km'])
    end
  end

  def load_rentals(rental_data)
    rental_data.map do |rental|
      Rental.new(
        id: rental['id'],
        car_id: rental['car_id'],
        start_date: rental['start_date'],
        end_date: rental['end_date'],
        distance: rental['distance']
      )
    end
  end

  def load_options(option_data)
    option_data.map { |option| Option.new(id: option['id'], rental_id: option['rental_id'], type: option['type']) }
  end

  def associate_options_to_rentals(_rentals, options)
    rental_options = Hash.new { |hash, key| hash[key] = [] }
    options.each { |option| rental_options[option.rental_id] << option }
    rental_options
  end

  def calculate_rental_prices(rentals, cars, rental_options)
    output = { rentals: [] }

    rentals.each do |rental|
      rental.options = rental_options[rental.id]

      rental_price = rental.price(cars)
      option_price = rental.option_price
      total_rental_price = rental_price + option_price

      commission = Commission.new(rental_price:, duration: rental.duration).calculate

      extra_owner_price = rental.options.select { |opt|
        opt.beneficiary == :owner
      }.map(&:price_per_day).sum * rental.duration
      extra_company_price = rental.options.select { |opt|
        opt.beneficiary == :company
      }.map(&:price_per_day).sum * rental.duration

      output[:rentals] << {
        id: rental.id,
        options: rental.options.map(&:type),
        actions: [
          { who: 'driver', type: 'debit', amount: total_rental_price },
          { who: 'owner', type: 'credit', amount: rental_price - commission.values.sum + extra_owner_price },
          { who: 'insurance', type: 'credit', amount: commission[:insurance_fee] },
          { who: 'assistance', type: 'credit', amount: commission[:assistance_fee] },
          { who: 'drivy', type: 'credit', amount: commission[:drivy_fee] + extra_company_price }
        ]
      }
    end
    output
  end
end
