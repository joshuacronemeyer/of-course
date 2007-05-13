class CourseController < ApplicationController

  def index
    redirect_to :action => "new"
  end
  
  def create
    @course = Course.new(:name => @params["name"], :description => @params["description"], :distance => @params["distance"])
    if @course.save
      saveGeocodesForCourse()
      redirect_to :action => "show", :id =>@course.id
    else
      render_action "new"
    end
  end

  def show
    @course = Course.find(@params["id"])
    @comment = Comment.new
  end
  
  def new
    @course = Course.new
  end
  
  def comment
    @course = Course.find(@params["id"])
    @comment = Comment.new(:text => @params["comment"], :author => @params["name"], :course_id => @course.id)
    if @comment.save
      redirect_to :action => "show", :id =>@params["id"]
    else
      render_action "show"
    end
  end
  
  private
  def saveGeocodesForCourse
    string = CGI::unescape(@params["coords"])
    string.gsub!(/[^-\.,\d]/,"")
    numbers = string.split(/,/)
    i = 0
    while i < numbers.length
      geocode = Geocode.new(:latitude => numbers[i], :longitude => numbers[i+1], :course_id => @course.id)
      geocode.save
      i = i + 2
    end
  end

end
