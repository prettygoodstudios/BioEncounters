class SpecieController < ActionController::Base
  protect_from_forgery with: :exception
  layout "application"
  def show
    @specie = Specie.find(params[:id])
    @locations = Location.joins(:encounters).where("encounters.specie_id = #{@specie.id}")
    @encounters = Encounter.where("specie_id = #{params[:id]}")
  end
end
