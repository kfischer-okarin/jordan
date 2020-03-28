# frozen_string_literal: true

module Jordan
  # Exceptions that can occur during actions
  module Exceptions
    class NotFound < StandardError; end
    class InvalidParameters < StandardError; end
    class Unprocessable < StandardError; end
  end
end
