class LegResult
  include Mongoid::Document

  field :secs, type: Float

  embeds_one :event, as: :parent
  embedded_in :entrant

  validates :event, presence: true

  after_initialize :calc_ave

  def secs=(value)
    self[:secs] = value

    calc_ave
  end

  def calc_ave
  end
end
