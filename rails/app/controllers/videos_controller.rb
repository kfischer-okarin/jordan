class VideosController < ApplicationController
  def register
    authorize!
    action = Jordan::Actions::RegisterVideo.new(videos: Video)
    action.execute(user_id: @user.id, youtube_id: params.require(:youtube_id))
  end

  private

  def authorize!
    match = /^Bearer (?<token>.+)$/.match(request.headers['Authorization'])
    @user = User.from_token match[:token]
  end
end
