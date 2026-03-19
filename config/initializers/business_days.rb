class Integer
  def business_days
    BusinessDaysDuration.new(self)
  end
end

class BusinessDaysDuration
  def initialize(days)
    @days = days


  end

  def after(time)
    result = time
    added = 0

    while added < @days
      result += 1.days
      next if result.saturday? || result.sunday?

      added += 1
    end

    result
  end
end