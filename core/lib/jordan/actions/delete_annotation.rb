# frozen_string_literal: true

module Jordan
  module Actions
    # Delete an annotation from a video (stream)
    class DeleteAnnotation
      def initialize(videos:, annotations:)
        @videos = videos
        @annotations = annotations
      end

      def execute(user_id:, annotation_id:)
        annotation = @annotations.get(annotation_id)
        video = @videos.get_by_youtube_id annotation.youtube_id
        raise Exceptions::Forbidden unless video.owner == user_id

        @annotations.delete(annotation_id)
      end
    end
  end
end
