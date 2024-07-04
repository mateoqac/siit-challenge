# frozen_string_literal: true

class Feature
  def price_per_day
    raise NotImplementedError
  end

  def beneficiary
    raise NotImplementedError
  end
end

class GpsFeature < Feature
  def price_per_day
    500
  end

  def beneficiary
    :owner
  end
end

class BabySeatFeature < Feature
  def price_per_day
    200
  end

  def beneficiary
    :owner
  end
end

class AdditionalInsuranceFeature < Feature
  def price_per_day
    1000
  end

  def beneficiary
    :company
  end
end
