class NormalizeCiOnPatients < ActiveRecord::Migration[7.0]
  def up
    Patient.where("ci ~ '[^0-9]'").find_each do |p|
      clean = p.ci.gsub(/\D/, '')
      next if clean == p.ci
      # keep "Pendiente" and similar non-numeric values as-is
      next if clean.empty?
      p.update_columns(ci: clean)
    end

    Patient.where("representante_ci ~ '[^0-9]'").find_each do |p|
      clean = p.representante_ci.gsub(/\D/, '')
      next if clean == p.representante_ci
      next if clean.empty?
      p.update_columns(representante_ci: clean)
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
