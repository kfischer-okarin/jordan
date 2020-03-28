# frozen_string_literal: true

module Jordan
  module Actions
    # Finalizes a livestream
    class FinalizeLivestream
      def initialize(videos:)
        @videos = videos
      end

      def execute(user_id:, video_id:)
        video = @videos.get(video_id)
        raise Exceptions::Forbidden unless video.owner == user_id
        raise Exceptions::Unprocessable, 'Only livestreams can be finalized' unless video.is_a? Entities::Livestream

        @videos.finalize(video_id)
      end
    end
  end
end
