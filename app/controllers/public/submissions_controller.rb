class Public::SubmissionsController < ApplicationController
  skip_before_action :authorize_request, only: [:index, :show, :create]
  before_action :set_submission, only: [:show, :update, :destroy]

  def index
    @submissions = Submission.all
    .page(submission_params[:page])
    .per(submission_params[:per_page])
  end

  def show
  end

  def create
    @submission = Submission.create!(submission_params)

    if @submission.save
      render :create, status: :ok
    else
      render json: @submission.errors, status: :unprocessable_entity
    end
  end

  def update
    if @submission.update(job_params_params)
      render :update, status: :ok
    else
      render json: @submission.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @submission.destroy
    head :no_content
  end

  private

  def submission_params
    params.permit(:name, :email, :mobile_phone, :resume, :job_id, :page, :per_page)
  end

  def set_submission
    @submission = Submission.find(params[:id])
  end
end
