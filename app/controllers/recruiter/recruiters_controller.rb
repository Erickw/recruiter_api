class Recruiter::RecruitersController < ApplicationController
  before_action :set_recruiter, only: [:show, :update, :destroy]

  def index
    @recruiters = Recruiter.all
  end

  def show
  end

  def update
    if @recruiter.update(recruiter_params)
      render :show, status: :ok
    else
      render json: @recruiter.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @recruiter.destroy
    head :no_content
  end

  private

  def recruiter_params
    params.permit(:name, :email, :password)
  end

  def set_recruiter
    @recruiter = Recruiter.find(params[:id])
  end
end
