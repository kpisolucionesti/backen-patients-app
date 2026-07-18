class SurgeriesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hospitalization

  def index
    authorize!('hospitalizacion.view')
    surgeries = @hospitalization.surgeries.order(surgery_date: :desc)
    render json: ::SurgeryRepresenter.for_collection.new(surgeries), status: :ok
  end

  def create
    authorize!('hospitalizacion.edit')
    surgery = @hospitalization.surgeries.build(surgery_params)
    if surgery.save
      render json: ::SurgeryRepresenter.new(surgery), status: :created
    else
      render json: { error: surgery.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('hospitalizacion.edit')
    surgery = @hospitalization.surgeries.find(params[:id])
    if surgery.update(surgery_params)
      render json: ::SurgeryRepresenter.new(surgery), status: :ok
    else
      render json: { error: surgery.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('hospitalizacion.edit')
    surgery = @hospitalization.surgeries.find(params[:id])
    surgery.destroy!
    head :no_content
  end

  private

  def set_hospitalization
    @hospitalization = Hospitalization.find(params[:hospitalization_id])
  end

  def surgery_params
    params.permit(:surgery_type, :description, :surgeon_name, :surgery_date, :status, :preop_notes, :postop_notes, :result)
  end
end
