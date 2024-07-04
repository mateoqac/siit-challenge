# frozen_string_literal: true

class Commission
  def initialize(rental_price:, duration:)
    @rental_price = rental_price
    @duration = duration
  end

  def calculate
    commission = (rental_price * 0.3).to_i
    insurance_fee = (commission / 2).to_i
    assistance_fee = (duration * 100).to_i
    drivy_fee = (commission - insurance_fee - assistance_fee).to_i

    {
      insurance_fee:,
      assistance_fee:,
      drivy_fee:
    }
  end

  private

  attr_reader :rental_price, :duration
end
