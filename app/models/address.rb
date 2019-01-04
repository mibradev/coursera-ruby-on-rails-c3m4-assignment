class Address
  attr_accessor :city
  attr_accessor :state
  attr_accessor :location

  class << self
    def demongoize(object)
      new(object[:city], object[:state], object[:loc]) if object
    end

    def evolve(object)
      object.mongoize
    end
  end

  def initialize(city, state, location)
    self.city = city
    self.state = state
    self.location = Point.demongoize(location)
  end

  def mongoize
    { city: city, state: state, loc: location.mongoize }
  end
end
