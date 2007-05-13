class CreateCourses < ActiveRecord::Migration
  def self.up
    create_table :courses do |t|
      t.column :name, :string
      t.column :distance, :float
      t.column :description, :string
    end
  end

  def self.down
    drop_table :courses
  end
end
