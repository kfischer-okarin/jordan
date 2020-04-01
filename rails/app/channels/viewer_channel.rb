class ViewerChannel < ApplicationCable::Channel
  class Gateway
    def self.notify(published_annotation)
      ActionCable.server.broadcast(
        published_annotation.youtube_id,
        {
          position: published_annotation.position,
          payload: published_annotation.payload
        }
      )
    end
  end

  def subscribed
    stream_from params[:youtube_id]
  end
end
