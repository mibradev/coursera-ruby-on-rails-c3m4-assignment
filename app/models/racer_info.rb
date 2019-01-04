class RacerInfo
  include Mongoid::Document

  field :_id, default: -> { racer_id }
  field :racer_id, as: :_id
  field :fn, as: :first_name, type: String
  field :ln, as: :last_name, type: String
  field :g, as: :gender, type: String
  field :yr, as: :birth_year, type: Integer
  field :res, as: :residence, type: Address

  embedded_in :parent, polymorphic: true

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :gender, presence: true, inclusion: { in: ["M", "F"] }
  validates :birth_year, presence: true, numericality: { less_than: Date.current.year }
end
