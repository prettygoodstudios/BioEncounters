class EncounterController < ActionController::Base
  protect_from_forgery with: :exception
  layout "application"
  before_action :is_signed_in, only: [:new]
  def show
    @encounter = Encounter.find(params[:id])
    @location = Location.find(@encounter.location_id)
    @specie = Specie.find(@encounter.specie_id)
  end
  def new
    @address = params[:address]
    @city = params[:city]
    @state = params[:state]
    @country = params[:country]
  end

  def is_signed_in
    if !signed_in?
      redirect_to root_path, alert: "You must sign in to access this content."
    end
  end
end
