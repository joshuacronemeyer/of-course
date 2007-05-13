require File.dirname(__FILE__) + '/../test_helper'

class GeocodeTest < Test::Unit::TestCase
  fixtures :geocodes

  # Replace this with your real tests.
  def test_northOf
    northern = geocode(0,0)
    assert(northern.northOf(nil))
    southern = geocode(-1,0)
    assert(!northern.northOf(southern))
    assert(!northern.northOf(northern))
    northerner = geocode(1,0)
    assert(!northern.northOf(northerner))
  end
  
  def test_southOf
    southern = geocode(0,0)
    assert(southern.southOf(nil))
    northern = geocode(1,0)
    assert(southern.southOf(northern))
    assert(!southern.southOf(southern))
    southerner = geocode(-1,0)
    assert(!southern.southOf(southerner))
  end
  
  def test_eastOf
    eastern = geocode(0,0)
    assert(eastern.eastOf(nil))
    western = geocode(0,-1)
    assert(eastern.eastOf(western))
    assert(!eastern.eastOf(eastern))
    easterner = geocode(0,1)
    assert(!eastern.eastOf(easterner))
  end
  
  def test_westOf
    western = geocode(0,0)
    assert(western.westOf(nil))
    eastern = geocode(0,1)
    assert(western.westOf(eastern))
    assert(!western.westOf(western))
    westerner = geocode(0,-1)
    assert(!western.westOf(westerner))
  end
  
  def test_to_s
    geocode = geocode(0,0)
    assert_equal("(0.0, 0.0)", geocode.to_s)
  end
  
  private
  def geocode(latitude, longitude)
    geocode = Geocode.new()
    geocode.latitude = latitude
    geocode.longitude = longitude
    return geocode
  end
end
