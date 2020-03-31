class AnnotationsController < ApplicationController
  before_action :authorize!

  def create
    action = Jordan::Actions::AddAnnotation.new(videos: Video, annotations: Annotation::Gateway)
    created = action.execute(
      user_id: @user.id,
      youtube_id: new_annotation_params[:youtube_id],
      payload: new_annotation_params[:payload]
    )

    render json: as_json(created), status: :created
  end

  private

  def as_json(annotation)
    %i[id payload position].map { |attribute| [attribute, annotation.send(attribute)] }.to_h
  end

  def new_annotation_params
    params.permit(:youtube_id, payload: {})
  end
end
