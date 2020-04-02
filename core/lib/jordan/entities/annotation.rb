# frozen_string_literal: true

module Jordan
  module Entities
    class Annotation
      attr_reader :id, :youtube_id, :video_timestamp, :position, :payload

      def initialize(id:, youtube_id:, position:, video_timestamp:, payload:)
        @id = id
        @youtube_id = youtube_id
        @position = position
        @video_timestamp = video_timestamp
        @payload = payload
      end
    end
  end
end
