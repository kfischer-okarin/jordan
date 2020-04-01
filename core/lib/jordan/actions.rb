# frozen_string_literal: true

module Jordan
  # Contains all the actions that are possible in the application
  # In Clean Architecture terms these are Interactors
  module Actions; end
end

require 'jordan/actions/add_annotation'
require 'jordan/actions/delete_annotation'
require 'jordan/actions/publish_annotation'
require 'jordan/actions/register_video'
