# frozen_string_literal: true

module Jordan
  module Actions
    # Register an annotable video
    class RegisterVideo
      def initialize(videos:)
        @videos = videos
      end

      def execute(user_id:, youtube_id:)
        @videos.register(owner: user_id, youtube_id: youtube_id)
      end
    end
  end
end
