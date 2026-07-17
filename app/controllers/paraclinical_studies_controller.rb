class ParaclinicalStudiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_emergency

  def index
    authorize!('emergencia.view')
    studies = @emergency.paraclinical_studies.order(created_at: :desc)
    render json: ::ParaclinicalStudyRepresenter.for_collection.new(studies), status: :ok
  end

  def create
    authorize!('emergencia.edit')
    study = @emergency.paraclinical_studies.new(study_params)
    if study.save
      render json: ::ParaclinicalStudyRepresenter.new(study), status: :created
    else
      render json: { error: study.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('emergencia.edit')
    study = @emergency.paraclinical_studies.find(params[:id])
    if study.update(study_params)
      render json: ::ParaclinicalStudyRepresenter.new(study), status: :ok
    else
      render json: { error: study.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('emergencia.edit')
    study = @emergency.paraclinical_studies.find(params[:id])
    study.destroy!
    head :no_content
  end

  private

  def set_emergency
    @emergency = Emergency.find(params[:emergency_id])
  end

  def study_params
    params.permit(:study_type, :description)
  end
end
