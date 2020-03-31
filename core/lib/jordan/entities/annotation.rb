# frozen_string_literal: true

module Jordan
  module Entities
    class Annotation
      attr_reader :youtube_id, :position, :payload

      def initialize(youtube_id:, position:, payload:)
        @youtube_id = youtube_id
        @position = position
        @payload = payload
      end
    end
  end
end
