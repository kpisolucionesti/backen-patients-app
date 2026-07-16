class ConvertIngressDateToDate < ActiveRecord::Migration[7.0]
  def up
    Emergency.where.not(ingress_date: nil).find_each do |e|
      parsed = Date.strptime(e.ingress_date, '%d/%m/%Y') rescue Date.strptime(e.ingress_date, '%d/%m/%y') rescue nil
      e.update_columns(ingress_date: parsed) if parsed
    end

    change_column :emergencies, :ingress_date, :date, using: 'ingress_date::date'
  end

  def down
    change_column :emergencies, :ingress_date, :string
  end
end
