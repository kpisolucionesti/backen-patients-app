class AddUniqueIndexToCiOnPatients < ActiveRecord::Migration[7.0]
  def change
    add_index :patients, :ci, unique: true
  end
end
