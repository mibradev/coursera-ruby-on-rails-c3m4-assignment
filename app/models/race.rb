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
  field :next_bib, type: Integer, default: 0

  embeds_many :events, as: :parent, class_name: "Event", order: :order.asc
  has_many :entrants, foreign_key: "race._id", dependent: :delete, order: [:secs.asc, :bib.asc]

  scope :upcoming, -> { where(:date.gte => Date.current) }
  scope :past, -> { where(:date.lt => Date.current) }

  class << self
    def default
      Race.new { |race| DEFAULT_EVENTS.each_key { |leg| race.send(leg) } }
    end

    def upcoming_available_to(racer)
      registered_race_ids = racer.races.upcoming.pluck("race._id").map { |race| race[:_id] }
      upcoming.nin(id: registered_race_ids)
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
    define_method(action) { location && location.send(action) }

    define_method("#{action}=") do |name|
      object = location || Address.new
      object.send("#{action}=", name)
      self.location = object
    end
  end

  def next_bib
    inc(next_bib: 1)
    self[:next_bib]
  end

  def get_group(racer)
    if racer && racer.birth_year && racer.gender
      min_age = (date.year - racer.birth_year) / 10 * 10
      max_age = min_age + 9

      Placing.demongoize(name: min_age >= 60 ? "masters #{racer.gender}" : "#{min_age} to #{max_age} (#{racer.gender})")
    end
  end

  def create_entrant(racer)
    Entrant.new do |entrant|
      entrant.build_race(attributes.symbolize_keys.slice(:_id, :n, :date))
      entrant.build_racer(racer.info.attributes)
      entrant.group = get_group(racer)
      events.each { |event| entrant.send("#{event.name}=", event) }

      if entrant.validate
        entrant.bib = next_bib
        entrant.save
      end
    end
  end
end
