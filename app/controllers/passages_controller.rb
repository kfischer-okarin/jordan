class PassagesController < ApplicationController
  include HTTParty

  def show
    response = self.class.get('http://labs.bible.org/api/', query: passage_params)
    render json: response
  end

  private

  def passage_params
    params.except(:action, :controller).to_unsafe_h
  end
end
