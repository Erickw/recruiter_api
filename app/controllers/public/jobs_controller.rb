class Public::JobsController < ApplicationController
  skip_before_action :authorize_request, only: [:index, :show]
  before_action :set_job, only: [:show]

  def index
    @jobs = Job.with_status_open.search(filter_params[:query])
    .page(filter_params[:page])
    .per(filter_params[:per_page])
  end

  def show
  end

  private

  def filter_params
    params.permit(:query, :page, :per_page)
  end

  def set_job
    @job = Job.find(params[:id])
  end

end
