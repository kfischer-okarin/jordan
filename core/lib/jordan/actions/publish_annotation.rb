
# frozen_string_literal: true

module Jordan
  module Actions
    # Publishes an annotation
    class PublishAnnotation
      def initialize(videos:, annotations:, viewers:)
        @videos = videos
        @annotations = annotations
        @viewers = viewers
      end

      def execute(user_id:, annotation_id:, position:)
        annotation = @annotations.get(annotation_id)
        video = @videos.get(annotation.video_id)

        raise Exceptions::Forbidden unless video.owner == user_id
        raise Exceptions::InvalidParameters, "Position can't be negative" if position.negative?

        annotation = @annotations.publish(annotation_id: annotation_id, position: position)
        @viewers.notify(annotation)
      end
    end
  end
end
