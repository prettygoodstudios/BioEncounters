class EncounterController < ActionController::Base
  protect_from_forgery with: :exception
  layout "application"
  before_action :set_encounter, only: [:show,:edit,:update]
  before_action :is_signed_in, only: [:new,:edit,:create,:update]
  before_action :authorized, only: [:edit,:update]
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
  def create
    @location = location_create
    if @location != nil
      @specie = specie_create
      if @specie != nil
        @encounter = Encounter.create(date: Date.parse(params[:date]), description: params[:description], location_id: @location.id, specie_id: @specie.id, user_id: current_user.id)
        if @encounter.save
          redirect_to encounter_path(@encounter.id), alert: "Successfully created encounter."
        else
          redirect_to new_encounter_path, alert: @encounter.errors.values.first.first
        end
      end
    end
  end
  def edit
    @location = Location.find(@encounter.location_id)
    @specie = Specie.find(@encounter.specie_id)
  end
  def update
    if @encounter.update_attributes(encounter_params)
      redirect_to encounter_path(@encounter.id), alert: "The encounter has been updated successfully."
    else
      redirect_to edit_encounter_path(@encounter.id), alert: @encounter.errors.values.first.first
    end
  end
  def location_create
    @location = Location.create(address: params[:address],city: params[:city], state: params[:state], country: params[:country], user_id: current_user.id)
    if @location.save
      return @location
    else
      if @location.errors.values.first.first == "This location already exists"
         @location = Location.where("city = '#{params[:city]}' AND address = '#{params[:address]}' And state = '#{params[:state]}'").first
         return @location
      else
        redirect_to new_encounter_path, alert: @location.errors.values.first.first
        return nil
      end
    end
  end
  def specie_create
    @specie = Specie.create(common: params[:common], scientific: params[:scientific], user_id: current_user.id)
    if @specie.save
      return @specie
    else
      if @specie.errors.values.first.first == "This specie is already in our system."
        return Specie.where("common = '#{params[:common]}' AND scientific = '#{params[:scientific]}'").first
      else
        redirect_to new_encounter_path, alert: @specie.errors.values.first.first
        return nil
      end
    end
  end
  def encounter_params
    params.permit(:description,:specie_id)
  end
  def set_encounter
    @encounter = Encounter.find(params[:id])
  end
  def is_signed_in
    redirect_to root_path, alert: "You must be logged in to perform this action." if current_user == nil
  end
  def authorized
    redirect_to root_path, alert: "You must be the owner of this content to perform this action." if !current_user.isMine(@encounter)
  end
end
