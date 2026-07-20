class SurgeryTeamMemberRepresenter < Representable::Decorator
  include Representable::JSON

  property :id
  property :surgery_id
  property :role

  property :doctor do
    property :id
    property :name
    property :speciality
  end

  collection_representer class: SurgeryTeamMember
end
