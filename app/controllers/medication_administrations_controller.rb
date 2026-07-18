class MedicationAdministrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hospitalization
  before_action :set_administration, only: [:update, :destroy]

  def index
    authorize!('hospitalizacion.view')
    administrations = @hospitalization.medication_administrations
                                      .includes(:administered_by, :medical_plan)
                                      .order(scheduled_at: :desc)
    render json: ::MedicationAdministrationRepresenter.for_collection.new(administrations), status: :ok
  end

  def create
    authorize!('hospitalizacion.nursing')
    administration = @hospitalization.medication_administrations.new(admin_params)
    administration.administered_by = @current_user if params[:administered_at].present?

    if administration.save
      render json: ::MedicationAdministrationRepresenter.new(administration), status: :created
    else
      render json: { error: administration.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('hospitalizacion.edit')
    if params[:administered_at].present? && !@administration.administered_at
      @administration.administered_by = @current_user
    end
    if @administration.update(admin_params)
      render json: ::MedicationAdministrationRepresenter.new(@administration), status: :ok
    else
      render json: { error: @administration.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('hospitalizacion.edit')
    @administration.destroy!
    head :no_content
  end

  private

  def set_hospitalization
    @hospitalization = Hospitalization.find(params[:hospitalization_id])
  end

  def set_administration
    @administration = @hospitalization.medication_administrations.find(params[:id])
  end

  def admin_params
    params.permit(:medical_plan_id, :medication_name, :dosage, :route, :frequency, :scheduled_at, :administered_at, :status, :notes)
  end
end
