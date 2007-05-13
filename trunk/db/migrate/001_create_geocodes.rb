class CreateGeocodes < ActiveRecord::Migration
  def self.up
    create_table :geocodes do |t|
      t.column :latitude, :float
      t.column :longitude, :float
    end
  end

  def self.down
    drop_table :geocodes
  end
end
