class LabParameterGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_lab_params

  def index
    scope = params[:include_inactive] == 'true' ? LabParameterGroup.all : LabParameterGroup.active
    groups = scope.includes(:lab_parameters).order(name: :asc)
    render json: groups.as_json(include: { lab_parameters: { only: [:id, :name, :unit, :abbreviation, :reference_ranges, :sort_order, :is_active] } }), status: :ok
  end

  def create
    group = LabParameterGroup.new(group_params)
    if group.save
      UserActivityLog.create!(
        user: @current_user,
        action: 'create_lab_parameter_group',
        description: "Creó grupo de parámetros '#{group.name}'"
      )
      render json: group.as_json(include: { lab_parameters: { only: [:id, :name, :unit, :abbreviation, :reference_ranges, :sort_order] } }), status: :created
    else
      render json: { error: group.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    group = LabParameterGroup.find(params[:id])
    if group.update(group_params)
      UserActivityLog.create!(
        user: @current_user,
        action: 'update_lab_parameter_group',
        description: "Actualizó grupo de parámetros '#{group.name}'"
      )
      render json: group.as_json(include: { lab_parameters: { only: [:id, :name, :unit, :abbreviation, :reference_ranges, :sort_order] } }), status: :ok
    else
      render json: { error: group.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    group = LabParameterGroup.find(params[:id])
    active_params = group.lab_parameters.where(is_active: true)
    if active_params.any?
      render json: { error: "No se puede suspender el grupo porque tiene #{active_params.count} parámetros activos asociados. Suspenda o reasigne los parámetros primero." }, status: :unprocessable_entity
      return
    end
    group.update!(is_active: false)
    UserActivityLog.create!(
      user: @current_user,
      action: 'suspend_lab_parameter_group',
      description: "Suspendió grupo de parámetros '#{group.name}'"
    )
    head :no_content
  end

  def restore
    group = LabParameterGroup.find(params[:id])
    group.update!(is_active: true)
    UserActivityLog.create!(
      user: @current_user,
      action: 'restore_lab_parameter_group',
      description: "Restauró grupo de parámetros '#{group.name}'"
    )
    render json: group.as_json(include: { lab_parameters: { only: [:id, :name, :unit, :abbreviation, :reference_ranges, :sort_order, :is_active] } }), status: :ok
  end

  private

  def group_params
    params.permit(:name, :description, :is_active, lab_parameters_attributes: [:id, :name, :unit, :abbreviation, :reference_ranges, :sort_order, :_destroy, :is_active])
  end

  def authorize_lab_params
    case action_name
    when 'index'
      authorize!('lab_params.view')
    else
      authorize!('lab_params.edit')
    end
  end
end
