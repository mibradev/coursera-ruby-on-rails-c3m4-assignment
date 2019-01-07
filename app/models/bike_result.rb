class BikeResult < LegResult
  include Mongoid::Document

  field :mph, type: Float

  def calc_ave
    if secs && event && event.miles
      self.mph = event.miles * 3600 / secs
    end
  end
end
