class Racer
  include Mongoid::Document

  embeds_one :info, as: :parent, class_name: "RacerInfo", autobuild: true
  has_many :races, class_name: "Entrant", foreign_key: "racer.racer_id", dependent: :nullify, order: :"race.date".desc

  before_create :set_racer_info_id

  private
    def set_racer_info_id
      info.id = id
    end
end
