class Public::JobsController < ApplicationController
  skip_before_action :authorize_request, only: [:index, :show]
  before_action :set_job, only: [:show]

  def index
    @jobs = Job.with_status_open.search(filter_params[:query])
  end

  def show
  end

  private

  def filter_params
    params.permit(:query)
  end

  def set_job
    @job = Job.find(params[:id])
  end

end
