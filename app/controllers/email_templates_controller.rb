class EmailTemplatesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  before_action :set_record, only: [:show, :update, :destroy, :preview]

  def index
    render json: EmailTemplate.order(:name).as_json, status: :ok
  end

  def show
    render json: @record.as_json, status: :ok
  end

  def create
    record = EmailTemplate.create!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'create_email_template', description: "Creo plantilla de correo '#{record.name}'")
    render json: record.as_json, status: :created
  end

  def update
    @record.update!(record_params)
    UserActivityLog.create!(user: @current_user, action: 'update_email_template', description: "Actualizo plantilla de correo '#{@record.name}'")
    render json: @record.as_json, status: :ok
  end

  def destroy
    UserActivityLog.create!(user: @current_user, action: 'delete_email_template', description: "Elimino plantilla de correo '#{@record.name}'")
    @record.destroy!
    head :no_content
  end

  def preview
    vars = (params[:variables] || {}).to_unsafe_h
    render json: { subject: @record.render_subject(vars), body: @record.render_body(vars) }, status: :ok
  end

  private

  def record_params
    p = params.permit(:name, :subject, :body_html, :template_type, :is_active, variables: [])
    p[:variables] = JSON.parse(p[:variables]) if p[:variables].is_a?(String)
    p
  end

  def set_record
    @record = EmailTemplate.find(params[:id])
  end

  def require_admin!
    unless @current_user&.admin?
      render json: { error: 'No autorizado' }, status: :forbidden
    end
  end
end
