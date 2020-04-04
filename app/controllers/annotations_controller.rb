class AnnotationsController < ApplicationController
  before_action :authorize, only: %i[index]
  before_action :authorize!, except: %i[index]
  before_action :find_video, only: %i[create reorder]
  before_action :authorize_for_video!, only: %i[create reorder]
  before_action :find_annotation, only: %i[publish update destroy]
  before_action :authorize_for_annotation!, only: %i[publish update destroy]

  def index
    result = Annotation.joins(:video).where(videos: { youtube_id: params.require(:youtube_id) })

    if @user
      result = result.order(:position)
      render json: result.map(&:json)
    else
      result = result.where.not(video_timestamp: nil).order(:video_timestamp)
      render json: result.map(&:public_json)
    end
  end

  def create
    annotation = Annotation.create(video: @video, payload: params.require(:payload))

    render json: annotation.json, status: :created
  end

  def publish
    raise InvalidOperation, 'Stream is already finished' if @annotation.video.streamed?

    @annotation.update(**publish_params)
    ViewerChannel.notify(@annotation)
    @annotation.video.update(status: :streaming) if @annotation.video.upcoming?
    render status: :ok
  end

  def reorder
    Annotation.transaction do
      annotation_by_id = @video.annotations.group_by(&:id)
      new_order = params[:_json].map(&:to_i)
      new_order.each.with_index do |id, index|
        annotation_by_id.fetch(id)[0].update(position: index + 1)
      end
    end

    render status: :ok
  end

  def update
    @annotation.update(**update_params)

    render json: @annotation.json
  end

  def destroy
    @annotation.destroy
  end

  private

  def find_annotation
    @annotation = Annotation.includes(:video).find(params[:id])
    raise Forbidden if @annotation.video.user_id != @user.id
  end

  def authorize_for_annotation!
    raise Forbidden unless @annotation.video.user == @user
  end

  def update_params
    params.require(:annotation).permit(payload: {})
  end

  def publish_params
    params.require(:annotation).permit(:video_timestamp)
  end
end
