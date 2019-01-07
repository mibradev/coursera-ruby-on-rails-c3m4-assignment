class RunResult < LegResult
  include Mongoid::Document

  field :mmile, as: :minute_mile, type: Float

  def calc_ave
    if secs && event && event.miles
      self.mmile = (secs / 60) / event.miles
    end
  end
end
