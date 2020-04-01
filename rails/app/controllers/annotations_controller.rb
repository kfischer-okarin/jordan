class AnnotationsController < ApplicationController
  before_action :authorize!

  def create
    action = Jordan::Actions::AddAnnotation.new(videos: Video::Gateway, annotations: Annotation::Gateway)
    created = action.execute(
      user_id: @user.id,
      youtube_id: new_annotation_params[:youtube_id],
      payload: new_annotation_params[:payload]
    )

    render json: as_json(created), status: :created
  end

  def publish
    action = Jordan::Actions::PublishAnnotation.new(
      annotations: Annotation::Gateway,
      videos: Video::Gateway,
      viewers: ViewerChannel::Gateway
    )
    action.execute(
      user_id: @user.id,
      annotation_id: publish_params[:id].to_i,
      position: publish_params[:position].to_i
    )
    render status: :ok
  end

  def destroy
    action = Jordan::Actions::DeleteAnnotation.new(annotations: Annotation::Gateway, videos: Video::Gateway)
    action.execute(
      user_id: @user.id,
      annotation_id: params.require(:id).to_i
    )
  end

  private

  def as_json(annotation)
    %i[id payload position].map { |attribute| [attribute, annotation.send(attribute)] }.to_h
  end

  def new_annotation_params
    {
      youtube_id: params.require(:youtube_id),
      payload: params.require(:payload).permit!
    }
  end

  def publish_params
    {
      id: params.require(:id),
      position: params.require(:position)
    }
  end
end
