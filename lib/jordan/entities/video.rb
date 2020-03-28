# frozen_string_literal: true

module Jordan
  module Entities
    # A video that can be annotated
    class Video
      attr_reader :owner, :duration

      def initialize(owner:, duration:)
        @owner = owner
        @duration = duration
      end
    end
  end
end
