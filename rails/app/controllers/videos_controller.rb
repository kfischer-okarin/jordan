class VideosController < ApplicationController
  before_action :authorize!

  def register
    action = Jordan::Actions::RegisterVideo.new(videos: Video::Gateway)
    action.execute(user_id: @user.id, youtube_id: params.require(:youtube_id))
  end
end
