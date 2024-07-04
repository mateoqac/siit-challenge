# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Commission do
  describe '#calculate' do
    context 'with valid input' do
      it 'returns the correct commission' do
        commission = Commission.new(rental_price: 3000, duration: 3)
        expect(commission.calculate).to eq(
          insurance_fee: 450,
          assistance_fee: 300,
          drivy_fee: 150
        )
      end
    end
  end
end
