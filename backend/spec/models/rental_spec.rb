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
    let(:cars) do
      [Car.new(id: 1, price_per_day: 2000, price_per_km: 10),
       Car.new(id: 2, price_per_day: 3000, price_per_km: 15)]
    end
    context 'when rental days is 1' do
      it 'does not apply any discount' do
        rental = Rental.new(id: 1, car_id: 1, start_date: '2017-12-08', end_date: '2017-12-08', distance: 100)
        expect(rental.price(cars)).to eq 3000
      end
    end

    context 'when rental days are between 2 and 4' do
      it 'applies a 10% discount on the price per day' do
        rental = Rental.new(id: 1, car_id: 1, start_date: '2017-12-08', end_date: '2017-12-09', distance: 300)
        expect(rental.price(cars)).to eq 6800
      end
    end

    context 'when rental days are between 5 and 10' do
      it 'applies a 30% discount on the price per day' do
        rental = Rental.new(id: 1, car_id: 1, start_date: '2017-12-8', end_date: '2017-12-14', distance: 100)
        expect(rental.price(cars)).to eq 12_600
      end
    end

    context 'when rental days are more than 10' do
      it 'applies a 50% discount on the price per day' do
        rental = Rental.new(id: 1, car_id: 1, start_date: '2017-12-03', end_date: '2017-12-14', distance: 1000)
        expect(rental.price(cars)).to eq 27_800
      end
    end
  end
end
