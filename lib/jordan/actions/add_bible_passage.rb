# frozen_string_literal: true

module Jordan
  module Actions
    # Add a Bible passage to the video stream
    class AddBiblePassage
      def initialize(videos:, annotations:, viewers:)
        @videos = videos
        @annotations = annotations
        @viewers = viewers
      end

      def execute(user_id:, video_id:, position:, passage:)
        raise Exceptions::InvalidParameters, 'Invalid position' if position.negative?

        video = @videos.get(video_id)
        raise Exceptions::Forbidden unless video.owner == user_id
        raise Exceptions::Unprocessable, 'Position cannot be outside video duration' if position >= video.duration

        @annotations.create(video_id: video_id, position: position, type: :bible_verse, passage: passage).tap { |created_annotation|
          @viewers.notify(created_annotation)
        }
      end
    end
  end
end
