# frozen_string_literal: true

require 'jordan/entities/video'

module Jordan
  module Entities
    # A livestream that can be annotated
    class Livestream < Video
      attr_reader :owner

      def initialize(owner:, start:)
        @owner = owner
        @start = start
      end

      def duration
        Time.now - @start
      end
    end
  end
end
