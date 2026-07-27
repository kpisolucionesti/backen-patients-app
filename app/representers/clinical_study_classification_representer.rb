class ClinicalStudyClassificationRepresenter
  def initialize(classification)
    @classification = classification
  end

  def to_json(*_args)
    {
      id: @classification.id,
      name: @classification.name,
      key: @classification.key,
      color: @classification.color,
      sort_order: @classification.sort_order,
      is_active: @classification.is_active,
      created_at: @classification.created_at,
      updated_at: @classification.updated_at,
    }
  end
end
