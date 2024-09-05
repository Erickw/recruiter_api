class AuthenticationController < ApplicationController
  skip_before_action :authorize_request, only: :authenticate

  def signin
    @recruiter = Recruiter.find_by(email: params[:email])

    if @recruiter&.authenticate(params[:password])
      token = encode_token({ recruiter_id: @recruiter.id })
      render json:  token , status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def signup
    @recruiter = Recruiter.new(recruiter_params)
    if @recruiter.save
      token = encode_token({ recruiter_id: @recruiter.id })
      render json: {message: "Account created successfully", token: token }, status: :created
    else
      render json: @recruiter.errors, status: :unprocessable_entity
    end
  end

  def reset_password
    @recruiter = Recruiter.find_by(email: params[:email])

    if @recruiter
      @recruiter.password = params[:new_password]
      if @recruiter.save
        render json: { message: 'Password updated successfully' }, status: :ok
      else
        render json: @recruiter.errors, status: :unprocessable_entity
      end
    else
      render json: { error: 'Recruiter not found' }, status: :not_found
    end
  end

  def encode_token(payload)
    expire_hours = ENV['JWT_EXPIRE_HOURS'].to_i
    expire_time = expire_hours.hours.from_now.to_i
    exp_payload = { data: payload, exp: expire_time }

    encoded = JWT.encode exp_payload, ENV['SECRET_KEY_BASE']
    {token: encoded, exp: Time.at(expire_time)}
  end

  private

  def recruiter_params
    params.require(:recruiter).permit(:name, :email, :password)
  end
end
