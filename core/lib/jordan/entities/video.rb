# frozen_string_literal: true

module Jordan
  module Entities
    # A video that can be annotated
    class Video
      attr_reader :owner

      def initialize(owner:)
        @owner = owner
      end
    end
  end
end
