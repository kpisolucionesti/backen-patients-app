class CreateStorageConfigurations < ActiveRecord::Migration[7.0]
  def change
    create_table :storage_configurations do |t|
      t.string :provider, default: "local"
      t.string :endpoint
      t.string :region
      t.string :bucket
      t.string :access_key_id
      t.string :secret_access_key
      t.string :local_path, default: "./storage"
      t.integer :max_file_size_mb, default: 10
      t.boolean :use_ssl, default: true
      t.timestamps
    end
  end
end
