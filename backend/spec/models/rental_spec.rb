# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Rental do
  describe '#initialize' do
    context 'with valid input' do
      it 'creates a new instance of Rental' do
        rental = Rental.new(id: 1, car_id: 1, start_date: '2017-12-8', end_date: '2017-12-10', distance: 100)
        expect(rental).to be_a Rental
      end
    end

    context 'with invalid input' do
      it 'raises an error' do
        expect do
          Rental.new(id: 1, car_id: 'Honda', start_date: '2017-12-8', end_date: '2017-12-10')
        end.to raise_error(ArgumentError)
      end
    end
  end

  describe '#price' do
    context 'with valid input' do
      it 'returns the price of the right rental' do
        cars = [Car.new(id: 1, price_per_day: 2000, price_per_km: 10),
                Car.new(id: 2, price_per_day: 3000, price_per_km: 15)]
        rental = Rental.new(id: 1, car_id: 1, start_date: '2017-12-8', end_date: '2017-12-10', distance: 100)
        expect(rental.price(cars)).to eq 7000
      end
    end
  end
end
