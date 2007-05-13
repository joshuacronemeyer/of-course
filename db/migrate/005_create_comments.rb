class CreateComments < ActiveRecord::Migration
  def self.up
    create_table :comments do |t|
      t.column :text, :string
      t.column :author, :string
      t.column :course_id, :int
    end
  end

  def self.down
    drop_table :comments
  end
end
