# frozen_string_literal: true

module Jordan
  module Actions
    # Add an annotation to a video (stream)
    class AddAnnotation
      def initialize(videos:, annotations:)
        @videos = videos
        @annotations = annotations
      end

      def execute(user_id:, video_id:, payload:)
        video = @videos.get(video_id)
        raise Exceptions::Forbidden unless video.owner == user_id

        @annotations.create(video_id: video_id, payload: payload)
      end
    end
  end
end
