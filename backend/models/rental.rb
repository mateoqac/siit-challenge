# frozen_string_literal: true

require 'date'

class Rental
  attr_accessor :id, :distance, :start_date, :end_date, :options, :car_id

  def initialize(id:, car_id:, start_date:, end_date:, distance:, options: [])
    @id = id
    @car_id = car_id
    @start_date = start_date
    @end_date = end_date
    @distance = distance
    @options = options
  end

  def price(cars)
    car = cars.find { |c| c.id == car_id }
    time_component(car) + distance_component(car)
  end

  def duration
    (Date.parse(end_date) - Date.parse(start_date)).to_i + 1
  end

  def option_price
    options.map(&:price_per_day).sum * duration
  end

  private

  def time_component(car)
    duration.times.reduce(0) do |sum, day|
      sum + (car.price_per_day * (1 - discount(day + 1)))
    end
  end

  def distance_component(car)
    car.price_per_km * distance
  end

  def discount(rental_days)
    case rental_days
    when 1
      0
    when 2..4
      0.1
    when 5..10
      0.3
    else
      0.5
    end
  end
end
