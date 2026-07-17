class LabParameterGroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_lab_params

  def index
    groups = LabParameterGroup.includes(:lab_parameters).order(name: :asc)
    render json: groups.as_json(include: { lab_parameters: { only: [:id, :name, :unit, :abbreviation, :reference_ranges, :sort_order] } }), status: :ok
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
    UserActivityLog.create!(
      user: @current_user,
      action: 'delete_lab_parameter_group',
      description: "Eliminó grupo de parámetros '#{group.name}'"
    )
    group.destroy!
    head :no_content
  end

  private

  def group_params
    params.permit(:name, :description, lab_parameters_attributes: [:id, :name, :unit, :abbreviation, :reference_ranges, :sort_order, :_destroy])
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
