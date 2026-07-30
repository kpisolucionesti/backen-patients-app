class DocumentsController < ApplicationController
  before_action :authenticate_user!

  PERMISSION_MAP = {
    'Emergency' => 'emergencia.documentos',
    'Hospitalization' => 'hospitalizacion.documentos',
    'Patient' => 'pacientes.documentos',
    'Surgery' => 'quirofano.documentos',
  }.freeze

  def index
    if params[:attachable_type].present? && params[:attachable_id].present?
      records = Document.where(
        attachable_type: params[:attachable_type],
        attachable_id: params[:attachable_id]
      )
      if params[:study_classification_id].present?
        records = records.where(study_classification_id: params[:study_classification_id])
      end
      records = records.order(created_at: :desc)
      render json: ::DocumentRepresenter.for_collection.new(records), status: :ok
    else
      render json: { error: 'attachable_type y attachable_id son requeridos' }, status: :unprocessable_entity
    end
  end

  def create
    authorize_document_action!(params[:attachable_type])
    document = Document.new(document_params)
    document.uploaded_by = @current_user
    if document.save
      render json: ::DocumentRepresenter.new(document), status: :created
    else
      render json: { error: document.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def destroy
    document = Document.find(params[:id])
    authorize_document_action!(document.attachable_type)
    document.file.purge if document.file.attached?
    document.destroy!
    head :no_content
  end

  def send_email
    document = Document.find(params[:id])
    authorize_document_action!(document.attachable_type)
    render json: { message: 'ODS enviada exitosamente' }, status: :ok
  end

  def update
    document = Document.find(params[:id])
    authorize_document_action!(document.attachable_type)
    if document.update(document_params)
      render json: ::DocumentRepresenter.new(document), status: :ok
    else
      render json: { error: document.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  private

  def authorize_document_action!(attachable_type)
    perm = PERMISSION_MAP[attachable_type]
    authorize!(perm) if perm
  end

  def document_params
    permitted = params.permit(
      :attachable_type, :attachable_id, :description, :file_type, :report_type, :file, :metadata,
      :study_classification_id, :study_type, :observations, :status
    )
    permitted[:metadata] = JSON.parse(permitted[:metadata]) if permitted[:metadata].is_a?(String)
    permitted
  end
end
