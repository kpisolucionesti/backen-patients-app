class LabParametersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_lab_params

  def index
    params = LabParameter.ordered.includes(:lab_parameter_group)
    render json: params.as_json(
      only: [:id, :name, :unit, :abbreviation, :reference_ranges, :sort_order, :lab_parameter_group_id, :created_at, :updated_at],
      include: { lab_parameter_group: { only: [:id, :name] } }
    ), status: :ok
  end

  def create
    param = LabParameter.new(param_params)
    if param.save
      UserActivityLog.create!(
        user: @current_user,
        action: 'create_lab_parameter',
        description: "Creó parámetro de laboratorio '#{param.name}'"
      )
      render json: param.as_json(
        only: [:id, :name, :unit, :abbreviation, :reference_ranges, :sort_order, :lab_parameter_group_id, :created_at, :updated_at],
        include: { lab_parameter_group: { only: [:id, :name] } }
      ), status: :created
    else
      render json: { error: param.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def update
    param = LabParameter.find(params[:id])
    if param.update(param_params)
      UserActivityLog.create!(
        user: @current_user,
        action: 'update_lab_parameter',
        description: "Actualizó parámetro de laboratorio '#{param.name}'"
      )
      render json: param.as_json(
        only: [:id, :name, :unit, :abbreviation, :reference_ranges, :sort_order, :lab_parameter_group_id, :created_at, :updated_at],
        include: { lab_parameter_group: { only: [:id, :name] } }
      ), status: :ok
    else
      render json: { error: param.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    param = LabParameter.find(params[:id])
    UserActivityLog.create!(
      user: @current_user,
      action: 'delete_lab_parameter',
      description: "Eliminó parámetro de laboratorio '#{param.name}'"
    )
    param.destroy!
    head :no_content
  end

  def import
    data = params[:data]
    return render json: { error: 'No data provided' }, status: :unprocessable_entity unless data.is_a?(Array)

    created = []
    errors = []

    data.each_with_index do |item, idx|
      group = nil
      if item[:group_name].present?
        group = LabParameterGroup.find_or_create_by!(name: item[:group_name])
      end

      reference_ranges = item[:reference_ranges]
      if reference_ranges.is_a?(String)
        begin
          reference_ranges = JSON.parse(reference_ranges)
        rescue JSON::ParserError
          reference_ranges = {}
        end
      end
      if (reference_ranges.blank? || reference_ranges == {}) && (item[:reference_range].present? || item[:ref].present?)
        reference_ranges = parse_legacy_reference_range(item[:reference_range] || item[:ref])
      end

      param = LabParameter.new(
        lab_parameter_group: group,
        name: item[:parameter_name] || item[:name],
        unit: item[:unit],
        abbreviation: item[:abbreviation],
        reference_ranges: reference_ranges || {},
        sort_order: idx
      )

      if param.save
        created << param
      else
        errors << { row: idx + 1, error: param.errors.full_messages.join(', ') }
      end
    end

    UserActivityLog.create!(
      user: @current_user,
      action: 'import_lab_parameters',
      description: "Importó #{created.size} parámetros de laboratorio desde Excel"
    )
    render json: { created: created.size, errors: errors }, status: :ok
  end

  private

  def param_params
    params.permit(:name, :unit, :abbreviation, :reference_ranges, :sort_order, :lab_parameter_group_id)
  end

  def parse_legacy_reference_range(str)
    return {} if str.blank?
    s = str.strip
    range = {}
    if s.include?('-') && s.scan(/-/).size == 1 && s !~ /\A[<>]/
      parts = s.split('-').map(&:strip)
      min = Float(parts[0]) rescue nil
      max = Float(parts[1]) rescue nil
      if min && max
        range = { type: 'range', min: min, max: max }
      end
    elsif s.start_with?('<')
      val = Float(s[1..].strip) rescue nil
      range = { type: 'inequality', comparator: '<', value: val } if val
    elsif s.start_with?('>')
      val = Float(s[1..].strip) rescue nil
      range = { type: 'inequality', comparator: '>', value: val } if val
    else
      range = { type: 'categorical', value: s }
    end
    return {} if range.empty?
    { 'male' => range, 'female' => range }
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
