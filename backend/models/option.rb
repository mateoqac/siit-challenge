# frozen_string_literal: true

require 'active_support/all'

class Option
  attr_accessor :id, :rental_id, :type

  def initialize(id:, rental_id:, type:)
    @type = type
    @rental_id = rental_id
    @id = id
    @feature = "#{@type.camelize}Feature".constantize.new
  end

  delegate :beneficiary, :price_per_day, to: :@feature
end
