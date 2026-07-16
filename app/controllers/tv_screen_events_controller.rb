class TvScreenEventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tv_screen

  def index
    authorize!('configuraciones.view')
    events = @tv_screen.events.order(created_at: :desc)
    events = events.where(event_type: params[:event_type]) if params[:event_type].present?
    events = events.where('created_at >= ?', params[:from]) if params[:from].present?
    events = events.where('created_at <= ?', params[:to]) if params[:to].present?

    render json: TvScreenEventRepresenter.for_collection.new(events), status: :ok
  end

  private

  def set_tv_screen
    @tv_screen = TvScreen.find(params[:tv_screen_id])
  end
end
