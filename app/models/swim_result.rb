class SwimResult < LegResult
  include Mongoid::Document

  field :pace_100, type: Float

  def calc_ave
    if secs && event && event.meters
      self.pace_100 = secs / (event.meters / 100)
    end
  end
end
