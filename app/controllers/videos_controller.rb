class VideosController < ApplicationController
  before_action :authorize!, except: %i[show]
  before_action :find_video, only: %i[show update]
  before_action :authorize_for_video!, only: %i[update]

  def index
    render json: Video.includes(:user).where(user: @user).map(&:json)
  end

  def register
    youtube_id = params.require(:youtube_id)
    raise InvalidOperation.new 'Video already exists' if Video.exists?(youtube_id: youtube_id)

    Video.create(user: @user, youtube_id: youtube_id)
  end

  def show
    render json: @video.public_json
  end

  def update
    @video.update(status: params.require(:status))
    render json: @video.json
  end
end
