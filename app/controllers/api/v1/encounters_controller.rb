class Api::V1::EncountersController < ApiController
  before_action :set_encounter, only: [:show, :update]
  before_action :is_authenticated, only: [:create, :update]
  before_action :is_mine, only: [:update]

  def index
    render json: Encounter.all
  end

  def show
    render json: @encounter
  end

  def create
    @location = location_create
    if @location != nil
      @specie = specie_create
      if @specie != nil
        begin
          @encounter = Encounter.create(date: Date.parse(params[:date].to_s), description: params[:description], location_id: @location.id, specie_id: @specie.id, user_id: @user.id)
          if @encounter.save
            render json: @encounter
          else
            render json: @encounter.errors
          end
        rescue StandardError => e
          render json: { errors: ["Must enter in a valid date in the correct format. Ex: 5th May 2016", e.backtrace ] }
        end
      end
    end
  end

  def update
    @location = location_create
    if @location != nil
      @specie = specie_create
      if @specie != nil
        if @encounter.update_attributes(encounter_params)
          @encounter.update_attribute("specie_id",@specie.id)
          @encounter.update_attribute("location_id",@location.id)
          render json: @encounter
        else
          render json: { errors: @encounters.errors }
        end
      end
    end
  end

  private
    #Location and Specie Create Helper Methods
    def location_create
      @location = Location.create(address: params[:address],city: params[:city], state: params[:state], country: params[:country], user_id: @user.id)
      if @location.save
        return @location
      else
        if @location.errors.values.first.first == "This location already exists"
           @location = Location.where("city = '#{params[:city]}' AND address = '#{params[:address]}' And state = '#{params[:state]}'").first
           return @location
        else
          render json: {errors: @location.errors}
          return nil
        end
      end
    end
    def specie_create
      puts "Error Found: #{params[:toggleSpecie] == nil}"
      if params[:toggleSpecie] != nil
        @specie = Specie.create(common: params[:common], scientific: params[:scientific], user_id: @user.id)
        if @specie.save
          return @specie
        else
          if @specie.errors.values.first.first == "This specie is already in our system."
            return Specie.where("common = '#{params[:common]}' AND scientific = '#{params[:scientific]}'").first
          else
            render json: { errors: @specie.errors }
            return nil
          end
        end
      else
        @specie = Specie.find(params[:specie])
        if @specie != nil
         return @specie
        else
          render json: { errors: ["Could Not Find Species"]}
        end
      end
    end

    #Before Actions and Params

    def encounter_params
      { description: params[:description]}
    end

    def set_encounter
      @encounter = Encounter.find(params[:id])
    end

    def is_authenticated
      if !User.authenticate_via_token params[:email], params[:token]
        head(:unauthorized)
      else
        @user = User.where("email = '#{params[:email]}'").first
      end
    end

    def is_mine
      puts "User #{@user.id} Encounter #{@encounter.user_id}"
      if !@user.is_mine @encounter
        head(:unauthorized)
      end
    end
end
