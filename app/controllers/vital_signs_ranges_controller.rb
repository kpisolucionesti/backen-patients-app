class VitalSignsRangesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_record, only: [:show, :update, :destroy]

  def index
    authorize!('configuraciones.view')
    render json: VitalSignsRange.active.ordered.as_json, status: :ok
  end

  def show
    authorize!('configuraciones.view')
    render json: @record.as_json, status: :ok
  end

  def create
    authorize!('configuraciones.view')
    record = VitalSignsRange.create!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'create_vital_signs_range', description: "Creo rango de signos vitales para #{VitalSignsRange::PARAMETER_LABELS[record.parameter.to_sym] || record.parameter}")
    render json: record.as_json, status: :created
  end

  def update
    authorize!('configuraciones.view')
    @record.update!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'update_vital_signs_range', description: "Actualizo rango de signos vitales para #{VitalSignsRange::PARAMETER_LABELS[@record.parameter.to_sym] || @record.parameter}")
    render json: @record.as_json, status: :ok
  end

  def destroy
    authorize!('configuraciones.view')
    UserActivityLog.create!(user: @current_user, action: 'delete_vital_signs_range', description: "Elimino rango de signos vitales para #{VitalSignsRange::PARAMETER_LABELS[@record.parameter.to_sym] || @record.parameter}")
    @record.destroy!
    head :no_content
  end

  private

  def record_params
    params.permit(:parameter, :age_min, :age_max, :sex, :min_normal, :max_normal, :min_alert, :max_alert, :is_active)
  end

  def set_record
    @record = VitalSignsRange.find(params[:id])
  end
end
