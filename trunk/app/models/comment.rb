class Comment < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :text, :author
end
