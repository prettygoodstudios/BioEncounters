class LocationController < ActionController::Base
  protect_from_forgery with: :exception
  layout "application"
  def index
    @locations = Location.all.order("city ASC")
  end
  def show
    @location = Location.find(params[:id])
    @encounters = Encounter.find_by_sql("SELECT e.*, s.common FROM encounters e JOIN species s ON e.specie_id = s.id WHERE e.location_id = #{params[:id].to_s} ORDER BY e.date DESC")
  end
  def playground

  end
  def geo_json_api
    render json: Location.all
  end
end
