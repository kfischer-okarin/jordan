# frozen_string_literal: true

module Jordan
  module Entities
    class Annotation
      attr_reader :id, :youtube_id, :position, :payload

      def initialize(id:, youtube_id:, position:, payload:)
        @id = id
        @youtube_id = youtube_id
        @position = position
        @payload = payload
      end
    end
  end
end
