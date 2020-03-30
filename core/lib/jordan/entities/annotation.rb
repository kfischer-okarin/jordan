# frozen_string_literal: true

module Jordan
  module Entities
    class Annotation
      attr_reader :video_id, :position, :payload

      def initialize(video_id:, position:, payload:)
        @video_id = video_id
        @position = position
        @payload = payload
      end
    end
  end
end
