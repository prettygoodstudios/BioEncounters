class Api::V1::SessionsController < ApiController

  def create
    user = User.where("email = '#{params[:email]}'").first
    if user&.valid_password?(params[:password])
      user.update_attribute("authentication_token",Devise.friendly_token)
      render json: user.as_json(only: [:id, :email, :authentication_token]), status: :created
    else
      head(:unauthorized)
    end
  end

  def destroy
    user = User.where("email = '#{params[:email]}'").first
    if user.authentication_token == params[:token]
      user.update_attribute("authentication_token",Devise.friendly_token)
      render json: user.as_json(only: [:id, :email, :authentication_token]), status: :created
    else
      head(:unauthorized)
    end
  end
end
