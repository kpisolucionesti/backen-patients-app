class SpecialtyRepresenter < Representable::Decorator
  include Representable::JSON
  property :id
  property :name
  property :description
  property :is_active
  property :doctors_count, exec_context: :decorator

  def doctors_count
    represented.doctors.size
  end
end
