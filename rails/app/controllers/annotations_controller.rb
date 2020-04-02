class AnnotationsController < ApplicationController
  before_action :authorize, only: %i[index]
  before_action :authorize!, except: %i[index]
  before_action :find_annotation, only: %i[publish destroy]

  def index
    result = Annotation.joins(:video).where(videos: { youtube_id: params.require(:youtube_id) })

    if @user
      result = result.order(:position)
      render json: result.map(&:as_json)
    else
      result = result.where.not(video_timestamp: nil).order(:video_timestamp)
      render json: result.map(&:as_json_public)
    end
  end

  def create
    video = Video.find_by!(youtube_id: params.require(:youtube_id))
    last_position = video.annotations.order(:position).last&.position || 0
    annotation = Annotation.create(video: video, position: last_position + 1, payload: params.require(:payload))

    render json: annotation.as_json, status: :created
  end

  def publish
    @annotation.update(video_timestamp: params.require(:video_timestamp).to_i)
    ViewerChannel.notify(@annotation)
    render status: :ok
  end

  def destroy
    @annotation.destroy
  end

  private

  def as_json(annotation)
    %i[id payload video_timestamp].map { |attribute| [attribute, annotation.send(attribute)] }.to_h
  end

  def as_json_public(annotation)
    %i[payload video_timestamp].map { |attribute| [attribute, annotation.send(attribute)] }.to_h
  end

  def find_annotation
    @annotation = Annotation.includes(:video).find(params[:id])
    raise Jordan::Exceptions::Forbidden if @annotation.video.user_id != @user.id
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
      video_timestamp: params.require(:video_timestamp)
    }
  end
end
