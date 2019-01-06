class Entrant
  include Mongoid::Document
  include Mongoid::Timestamps

  RESULTS = {
    swim: SwimResult,
    t1: LegResult,
    bike: BikeResult,
    t2: LegResult,
    run: RunResult
  }

  store_in collection: :results

  field :bib, type: Integer
  field :secs, type: Float
  field :o, as: :overall, type: Placing
  field :gender, type: Placing
  field :group, type: Placing

  embeds_one :racer, as: :parent, class_name: "RacerInfo", autobuild: true
  embeds_one :race, class_name: "RaceRef", autobuild: true
  embeds_many :results, class_name: "LegResult", order: :"event.o".asc, after_add: :update_total

  delegate :first_name, :first_name=, to: :racer
  delegate :last_name, :last_name=, to: :racer
  delegate :gender, :gender=, to: :racer, prefix: :racer
  delegate :birth_year, :birth_year=, to: :racer
  delegate :city, :city=, to: :racer
  delegate :state, :state=, to: :racer
  delegate :name, :name=, to: :race, prefix: :race
  delegate :date, :date=, to: :race, prefix: :race

  RESULTS.each_key do |name|
    define_method(name) do
      result = results.select { |result| name.to_s == result.event.name if result.event }.first

      unless result
        result = RESULTS[name].new(event: { name: name })
        results << result
      end

      result
    end

    define_method("#{name}=") do |event|
      event = send(name).build_event(event.attributes)
    end

    RESULTS[name].attribute_names.reject { |r| /^_/ === r }.each do |prop|
      define_method("#{name}_#{prop}") { event = send(name).send(prop) }

      define_method("#{name}_#{prop}=") do |value|
        event = send(name).send("#{prop}=", value)
        update_total nil if /secs/ === prop
      end
    end
  end

  def update_total(result)
    self.secs = results.inject(0) { |sum, r| sum + r.secs.to_f }
  end

  def the_race
    race.race
  end

  def overall_place
    overall.place if overall
  end

  def gender_place
    gender.place if gender
  end

  def group_name
    group.name if group
  end

  def group_place
    group.place if group
  end
end
