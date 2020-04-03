class VideosController < ApplicationController
  before_action :authorize, only: %i[index]
  before_action :authorize!, except: %i[index show]
  before_action :find_video, only: %i[show update]
  before_action :authorize_for_video!, only: %i[update]

  def index
    videos = Video.includes(:user)
    if @user
      videos = videos.where(user: @user)
      render json: videos.map(&:public_json)
    else
      render json: videos.map(&:public_json)
    end
  end

  def register
    youtube_id = register_params[:youtube_id]
    raise InvalidOperation.new 'Video already exists' if Video.exists?(youtube_id: youtube_id)

    Video.create(user: @user, youtube_id: youtube_id, **register_params)
  end

  def show
    render json: @video.public_json
  end

  def update
    @video.update(**update_params)
    render json: @video.json
  end

  private

  def update_params
    params.permit(:youtube_id, :status).except(:youtube_id)
  end

  def register_params
    params.permit(:youtube_id, :title)
  end
end
