class MedicalPlansController < ApplicationController
  before_action :authenticate_user!
  before_action :set_emergency
  before_action :set_medical_plan, only: [:update, :destroy]

  def index
    authorize!('emergencia.view')
    plans = @emergency.medical_plans.includes(:doctor, :created_by).order(created_at: :desc)
    render json: ::MedicalPlanRepresenter.for_collection.new(plans), status: :ok
  end

  def create
    authorize!('emergencia.edit')
    plan = @emergency.medical_plans.new(medical_plan_params)
    plan.created_by = @current_user
    if plan.save
      render json: ::MedicalPlanRepresenter.new(plan), status: :created
    else
      render json: { error: plan.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    authorize!('emergencia.edit')
    if @medical_plan.update(medical_plan_params)
      render json: ::MedicalPlanRepresenter.new(@medical_plan), status: :ok
    else
      render json: { error: @medical_plan.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    authorize!('emergencia.edit')
    @medical_plan.destroy!
    head :no_content
  end

  private

  def set_emergency
    @emergency = Emergency.find(params[:emergency_id])
  end

  def set_medical_plan
    @medical_plan = @emergency.medical_plans.find(params[:id])
  end

  def medical_plan_params
    params.permit(:description, :indication_type, :status, :completed_at, :doctor_id)
  end
end
