class Placing
  attr_accessor :name
  attr_accessor :place

  class << self
    def demongoize(object)
      new(object[:name], object[:place]) if object
    end

    def evolve(object)
      object.mongoize
    end
  end

  def initialize(name, place)
    self.name = name
    self.place = place
  end

  def mongoize
    { name: name, place: place }
  end
end
