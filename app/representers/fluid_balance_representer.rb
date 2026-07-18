class FluidBalanceRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :hospitalization_id
  property :balance_type
  property :balance_type_label
  property :fluid_type
  property :fluid_type_label
  property :amount
  property :unit
  property :recorded_at
  property :created_at
  property :updated_at

  property :recorded_by do
    property :id
    property :name
    property :lastname
  end
end
