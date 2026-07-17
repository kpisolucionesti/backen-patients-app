class UpdateLabParametersWithAbbreviationAndRanges < ActiveRecord::Migration[7.0]
  def change
    LabResultValue.delete_all
    LaboratoryResult.delete_all
    LabParameter.delete_all
    LabParameterGroup.delete_all

    add_column :lab_parameters, :abbreviation, :string
    add_column :lab_parameters, :reference_ranges, :jsonb, default: {}
    remove_column :lab_parameters, :reference_range, :string
  end
end
