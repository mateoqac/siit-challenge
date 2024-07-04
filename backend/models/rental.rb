# frozen_string_literal: true

require 'date'

class Rental
  attr_accessor :id, :car_id, :start_date, :end_date, :distance

  def initialize(id:, car_id:, start_date:, end_date:, distance:)
    @id = id
    @car_id = car_id
    @start_date = start_date
    @end_date = end_date
    @distance = distance
  end

  def price(cars)
    car = cars.find { |car| car.id == car_id }
    rental_days = (Date.parse(end_date) - Date.parse(start_date)).to_i + 1
    time_component = car.price_per_day * rental_days
    distance_component = car.price_per_km * distance
    time_component + distance_component
  end
end
