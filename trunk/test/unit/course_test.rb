require File.dirname(__FILE__) + '/../test_helper'

class CourseTest < Test::Unit::TestCase
  fixtures :courses

  def test_center
    course = origin_centered_course
    center = geocode(0,0)
    assert_equal("#{center.latitude},#{center.longitude}", course.center)
    course = zero_sized_origin_centered_course
    assert_equal("#{center.latitude},#{center.longitude}", course.center)
    course = non_origin_centered_course
    center = geocode(2,1)
    assert_equal("#{center.latitude},#{center.longitude}", course.center)
  end
  
  def test_csv_of_geocodes
    course = Course.new
    north = geocode(1,0)
    south = geocode(-1,0)
    course.geocodes = [north, south]
    assert_equal("#{north.latitude},#{north.longitude},#{south.latitude},#{south.longitude}", course.csv_of_geocodes)
  end
  
  private
  def geocode(latitude, longitude)
    geocode = Geocode.new()
    geocode.latitude = latitude
    geocode.longitude = longitude
    return geocode
  end
  
  def zero_sized_origin_centered_course()
    course = Course.new
    north = geocode(0,0)
    south = geocode(0,0)
    east = geocode(0,0)
    west = geocode(0,0)
    course.geocodes = [north, south, east, west]
    return course
  end
  
  def origin_centered_course()
    course = Course.new
    north = geocode(1,0)
    south = geocode(-1,0)
    east = geocode(0,1)
    west = geocode(0,-1)
    course.geocodes = [north, south, east, west]
    return course
  end
  
  def non_origin_centered_course()
    course = Course.new
    north = geocode(10,1)
    south = geocode(-6,2)
    east = geocode(-5,3)
    west = geocode(0,-1)
    course.geocodes = [north, south, east, west]
    return course
  end
end
