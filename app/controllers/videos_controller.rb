class VideosController < ApplicationController
  before_action :authorize!

  def register
    Video.create(user: @user, youtube_id: params.require(:youtube_id))
  end
end
