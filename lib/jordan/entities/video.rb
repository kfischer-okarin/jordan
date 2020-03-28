# frozen_string_literal: true

module Jordan
  module Entities
    # A video that can be annotated
    class Video
      attr_reader :duration

      def initialize(duration:)
        @duration = duration
      end
    end
  end
end
