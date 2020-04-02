class VideosController < ApplicationController
  before_action :authorize!

  def register
    youtube_id = params.require(:youtube_id)
    raise InvalidOperation.new 'Video already exists' if Video.exists?(youtube_id: youtube_id)

    Video.create(user: @user, youtube_id: youtube_id)
  end
end
