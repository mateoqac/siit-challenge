# frozen_string_literal: true

require 'date'

class Rental
  attr_accessor :id, :distance

  def initialize(id:, car_id:, start_date:, end_date:, distance:)
    @id = id
    @car_id = car_id
    @start_date = start_date
    @end_date = end_date
    @distance = distance
  end

  def price(cars)
    car = cars.find { |car| car.id == car_id }

    time_component = duration.times.reduce(0) do |sum, day|
      sum + (car.price_per_day * (1 - discount(day + 1)))
    end
    distance_component = car.price_per_km * distance
    time_component + distance_component
  end

  def duration
    (Date.parse(end_date) - Date.parse(start_date)).to_i + 1
  end

  private

  attr_accessor :car_id, :start_date, :end_date

  def discount(rental_days)
    if rental_days > 10
      0.5
    elsif rental_days > 4
      0.3
    elsif rental_days > 1
      0.1
    else
      0
    end
  end
end
