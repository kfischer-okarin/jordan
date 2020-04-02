class ViewerChannel < ApplicationCable::Channel
  class Gateway

  end

  def self.notify(published_annotation)
    ActionCable.server.broadcast(
      published_annotation.youtube_id,
      {
        video_timestamp: published_annotation.video_timestamp,
        payload: published_annotation.payload
      }
    )
  end

  def subscribed
    stream_from params[:youtube_id]
  end
end
