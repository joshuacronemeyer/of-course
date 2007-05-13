class Geocode < ActiveRecord::Base
  belongs_to :course
  validates_presence_of :longitude, :latitude, :course_id
  
  def to_s
    return "(#{latitude}, #{longitude})"
  end
  
  def northOf(other)
    return true if other.nil?
    return latitude > other.latitude
  end
  
  def southOf(other)
    return true if other.nil?
    return latitude < other.latitude
  end
  
  def eastOf(other)
    return true if other.nil?
    return longitude > other.longitude
  end
  
  def westOf(other)
    return true if other.nil?
    return longitude < other.longitude
  end

end
