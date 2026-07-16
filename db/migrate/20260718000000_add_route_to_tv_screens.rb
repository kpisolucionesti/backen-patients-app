class AddRouteToTvScreens < ActiveRecord::Migration[7.0]
  def up
    add_column :tv_screens, :route, :string

    TvScreen.reset_column_information
    TvScreen.find_each do |screen|
      base = screen.name.downcase.gsub(/[^a-z0-9]/, '-').gsub(/-+/, '-').gsub(/\A-|-\z/, '')
      base = 'pantalla' if base.blank?
      route = base
      counter = 1
      while TvScreen.where(route: route).where.not(id: screen.id).exists?
        counter += 1
        route = "#{base}-#{counter}"
      end
      screen.update!(route: route)
    end

    change_column_null :tv_screens, :route, false
    add_index :tv_screens, :route, unique: true
  end

  def down
    remove_index :tv_screens, :route
    remove_column :tv_screens, :route
  end
end
