class AddColumnToGeocodes < ActiveRecord::Migration
  def self.up
    add_column "geocodes", "course_id", "int"
  end

  def self.down
    remove_column "geocodes", "course_id"
  end
end
