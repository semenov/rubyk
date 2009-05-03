class AddOpenIdStoreToDb < ActiveRecord::Migration
  def self.up
    create_table :open_id_associations do |t|
      t.string :server_url
      t.string :handle
      t.binary :secret
      t.integer :issued
      t.integer :lifetime
      t.string :assoc_type
    end

    create_table :open_id_nonces do |t|
      t.string :server_url
      t.integer :timestamp
      t.string :salt
    end
  end

  def self.down
    drop_table :open_id_associations
    drop_table :open_id_nonces
  end
end
