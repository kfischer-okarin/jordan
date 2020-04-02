class AnnotationsController < ApplicationController
  before_action :authorize, only: %i[index]
  before_action :authorize!, except: %i[index]
  before_action :find_video, only: %i[create reorder]
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
    annotation = Annotation.create(video: @video, payload: params.require(:payload))

    render json: annotation.as_json, status: :created
  end

  def publish
    @annotation.update(video_timestamp: params.require(:video_timestamp).to_i)
    ViewerChannel.notify(@annotation)
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

  def destroy
    @annotation.destroy
  end

  private

  def find_video
    @video = Video.find_by!(youtube_id: params.require(:youtube_id))
  end

  def find_annotation
    @annotation = Annotation.includes(:video).find(params[:id])
    raise Forbidden if @annotation.video.user_id != @user.id
  end
end
