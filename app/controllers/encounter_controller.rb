class EncounterController < ActionController::Base
  protect_from_forgery with: :exception
  layout "application"
  before_action :set_encounter, only: [:show,:edit,:update]
  before_action :is_signed_in, only: [:new,:edit,:create,:update,:my_encounters]
  before_action :authorized, only: [:edit,:update]
  def show
    @location = Location.find(@encounter.location_id)
    @user = User.find(@encounter.user_id)
    @specie = Specie.find(@encounter.specie_id)
  end
  def new
    @address = params[:address]
    @city = params[:city]
    @state = params[:state]
    @country = params[:country]
  end
  def create
    return_path = new_encounter_path
    @location = location_create return_path
    if @location != nil
      @specie = specie_create return_path
      if @specie != nil
        begin
          @encounter = Encounter.create(date: Date.parse(params[:date]), description: params[:description], location_id: @location.id, specie_id: @specie.id, user_id: current_user.id)
          if @encounter.save
            redirect_to encounter_path(@encounter.id), alert: "Successfully created encounter."
          else
            redirect_to return_path, alert: @encounter.errors.values.first.first
          end
        rescue
          redirect_to return_path, alert: "Must enter in a valid date in the correct format. MM/DD/YYYY."
        end
      end
    end
  end
  def edit
    @location = Location.find(@encounter.location_id)
    @specie = Specie.find(@encounter.specie_id)
  end
  def update
    return_path = edit_encounter_path(id: @encounter.id)
    @location = location_create return_path
    if @location != nil
      @specie = specie_create return_path
      if @specie != nil
        if @encounter.update_attributes(encounter_params)
          @encounter.update_attribute("specie_id",@specie.id)
          @encounter.update_attribute("location_id",@location.id)
          redirect_to encounter_path(@encounter.id), alert: "The encounter has been updated successfully."
        else
          redirect_to edit_encounter_path(return_path), alert: @encounter.errors.values.first.first
        end
      end
    end
  end
  def my_encounters
    @encounters = Encounter.where("user_id = #{current_user.id}")
  end
  def user_encounters
    @user = User.find(params[:user])
    @encounters = Encounter.where("user_id = #{params[:user]}")
  end
  def get_by_date
    @date = params[:date]
    @encounters = Encounter.where("date = '#{params[:date]}'")
  end
  def get_by_range
    @start = params[:start]
    @end = params[:end]
    @encounters = Encounter.date_range(params[:start],params[:end])
    @month = (@encounters.first.get_month[:start].to_s == @start && @encounters.first.get_month[:end].to_s == @end) ? "#{@start.split('-')[1]}/#{@start.split('-')[0]}" : false
  end
  def location_create return_path
    @location = Location.create(address: params[:address],city: params[:city], state: params[:state], country: params[:country], user_id: current_user.id)
    if @location.save
      return @location
    else
      if @location.errors.values.first.first == "This location already exists"
         @location = Location.where("city = '#{params[:city]}' AND address = '#{params[:address]}' And state = '#{params[:state]}'").first
         return @location
      else
        redirect_to return_path, alert: @location.errors.values.first.first
        return nil
      end
    end
  end
  def specie_create return_path
    puts "Error Found: #{params[:toggleSpecie] == nil}"
    if params[:toggleSpecie] != nil
      @specie = Specie.create(common: params[:common], scientific: params[:scientific], user_id: current_user.id)
      if @specie.save
        return @specie
      else
        if @specie.errors.values.first.first == "This specie is already in our system."
          return Specie.where("common = '#{params[:common]}' AND scientific = '#{params[:scientific]}'").first
        else
          redirect_to return_path, alert: @specie.errors.values.first.first
          return nil
        end
      end
    else
      @specie = Specie.find(params[:specie])
      if @specie != nil
       return @specie
      else
        redirect_to return_path, alert: "Could not find species."
      end
    end
  end
  def get_by_date_api
    @encounters = Encounter.date_range(params[:date],params[:date])
    render json: @encounters
  end
  def get_by_range_api
    @encounters = Encounter.date_range(params[:start],params[:end])
    render json: @encounters
  end
  def encounter_params
    params.permit(:description)
  end
  def set_encounter
    @encounter = Encounter.find(params[:id])
  end
  def is_signed_in
    redirect_to root_path, alert: "You must be logged in to perform this action." if current_user == nil
  end
  def authorized
    redirect_to root_path, alert: "You must be the owner of this content to perform this action." if !current_user.is_mine(@encounter)
  end
end
