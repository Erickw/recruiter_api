class Recruiter::JobsController < ApplicationController
  before_action :set_job, only: [:show, :update, :destroy]
    def index
      @jobs = Job.all
      .page(job_params[:page])
      .per(job_params[:per_page])
    end

    def show
    end

    def create
      @job = Job.create!(job_params)

      if @job.save
        render :create, status: :ok
      else
        render json: @job.errors, status: :unprocessable_entity
      end
    end

    def update
      if @job.update(job_params)
        render :update, status: :ok
      else
        render json: @job.errors, status: :unprocessable_entity
      end
    end

    def destroy
      @job.destroy
      head :no_content
    end

    private

    def job_params
      params.permit(:title, :description, :start_date, :end_date, :status, :skills, :recruiter_id, :page, :per_page)
    end

    def set_job
      @job = Job.find(params[:id])
    end
end
