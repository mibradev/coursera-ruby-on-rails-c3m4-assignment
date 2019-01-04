class Point
  attr_accessor :longitude
  attr_accessor :latitude

  class << self
    def demongoize(object)
      new(object[:coordinates][0], object[:coordinates][1]) if object
    end

    def evolve(object)
      object.mongoize
    end
  end

  def initialize(longitude, latitude)
    self.longitude = longitude
    self.latitude = latitude
  end

  def mongoize
    { type: "Point", coordinates: [longitude, latitude] }
  end
end
