class MedicationAdministrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_parent
  before_action :set_administration, only: [:update, :destroy]

  def index
    authorize!('hospitalizacion.view')
    administrations = @parent.medication_administrations
                              .includes(:administered_by, :medical_plan)
                              .order(scheduled_at: :desc)
    render json: ::MedicationAdministrationRepresenter.for_collection.new(administrations), status: :ok
  end

  def create
    authorize!('hospitalizacion.nursing')
    administration = @parent.medication_administrations.new(admin_params)
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

  def set_parent
    if params[:hospitalization_id].present?
      @parent = Hospitalization.find(params[:hospitalization_id])
    elsif params[:emergency_id].present?
      @parent = Emergency.find(params[:emergency_id])
    else
      render json: { error: 'hospitalization_id o emergency_id requerido' }, status: :unprocessable_entity
    end
  end

  def set_administration
    @administration = @parent.medication_administrations.find(params[:id])
  end

  def admin_params
    params.permit(:medical_plan_id, :medication_name, :dosage, :route, :frequency, :scheduled_at, :administered_at, :status, :notes)
  end
end