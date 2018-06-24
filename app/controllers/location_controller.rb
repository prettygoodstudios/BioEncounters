class LocationController < ActionController::Base
  protect_from_forgery with: :exception
  layout "application"
  def index
    @locations = Location.all.order("city ASC")
  end
  def show
    @location = Location.find(params[:id])
    @encounters = Encounter.find_by_sql("SELECT e.* FROM encounters e JOIN locations l ON e.location_id = l.id WHERE l.id = #{params[:id].to_s} ORDER BY e.date DESC")
  end
  def playground

  end
end
