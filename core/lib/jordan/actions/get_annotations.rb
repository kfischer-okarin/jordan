# frozen_string_literal: true

module Jordan
  module Actions
    # Get all annotations of a video (stream)
    class GetAnnotations
      def initialize(videos:, annotations:)
        @videos = videos
        @annotations = annotations
      end

      def execute(user_id:, youtube_id:)
        video = @videos.get_by_youtube_id youtube_id
        if video.owner == user_id
          @annotations.get_all_annotations(youtube_id: youtube_id)
        else
          @annotations.get_all_annotations(youtube_id: youtube_id, published_only: true)
        end
      end
    end
  end
end
