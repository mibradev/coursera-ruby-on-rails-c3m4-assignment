class Racer
  include Mongoid::Document

  embeds_one :info, as: :parent, class_name: "RacerInfo", autobuild: true

  before_create :set_racer_info_id

  private
    def set_racer_info_id
      info.id = id
    end
end
