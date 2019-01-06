class Race
  include Mongoid::Document
  include Mongoid::Timestamps

  DEFAULT_EVENTS = {
    "swim" => { order: 0, name: "swim", distance: 1.0, units: "miles" },
    "t1" => { order: 1, name: "t1" },
    "bike" => { order: 2, name: "bike", distance: 25.0, units: "miles" },
    "t2" => { order: 3, name: "t2" },
    "run" => { order: 4, name: "run", distance: 10.0, units: "kilometers" }
  }

  field :n, as: :name, type: String
  field :date, type: Date
  field :loc, as: :location, type: Address

  embeds_many :events, as: :parent, class_name: "Event", order: :order.asc
  has_many :entrants, foreign_key: "race._id", dependent: :delete, order: [:secs.asc, :bib.asc]

  scope :upcoming, -> { where(:date.gte => Date.current) }
  scope :past, -> { where(:date.lt => Date.current) }

  class << self
    def default
      Race.new { |race| DEFAULT_EVENTS.each_key { |leg| race.send(leg) } }
    end
  end

  DEFAULT_EVENTS.each_key do |name|
    define_method(name) do
      event = events.select { |event| name == event.name }.first
      event ||= events.build(DEFAULT_EVENTS[name])
    end

    [:order, :distance, :units].each do |prop|
      if DEFAULT_EVENTS[name][prop]
        define_method("#{name}_#{prop}") { event = send(name).send(prop) }

        define_method("#{name}_#{prop}=") do |value|
          event = send(name).send("#{prop}=", value)
        end
      end
    end
  end

  [:city, :state].each do |action|
    define_method(action) { location&.send(action) }

    define_method("#{action}=") do |name|
      object = location || Address.new
      object.send("#{action}=", name)
      self.location = object
    end
  end
end
