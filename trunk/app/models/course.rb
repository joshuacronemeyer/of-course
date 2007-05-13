class Course < ActiveRecord::Base
  has_many :comments
  has_many :geocodes
  validates_presence_of :name, :distance
  validates_uniqueness_of :name
  def validate
    errors.add_to_base("Your course isn't long enough.") if distance && distance <= 0
  end
  
  def csv_of_geocodes
    csv = ""
    for geocode in geocodes
      csv = csv + "#{geocode.latitude},#{geocode.longitude},"
    end
    return csv.chop!
  end
  
  def center
    northern, southern, eastern, western = nil
    for challenger in geocodes
      northern = challenger if challenger.northOf(northern)
      southern = challenger if challenger.southOf(southern)
      eastern = challenger if challenger.eastOf(eastern)
      western = challenger if challenger.westOf(western)
    end
    return "#{centerLatitudeOf(northern, southern)},#{centerLongitudeOf(eastern, western)}"
  end
  
  private
  def centerLatitudeOf(northern, southern)
    return northern.latitude - (northern.latitude - southern.latitude)/2.00
  end
  
  def centerLongitudeOf(eastern, western)
    return eastern.longitude - (eastern.longitude - western.longitude)/2.00
  end
  
end
