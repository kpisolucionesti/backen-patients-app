class DocumentsController < ApplicationController
  before_action :authenticate_user!

  def index
    if params[:attachable_type].present? && params[:attachable_id].present?
      records = Document.where(
        attachable_type: params[:attachable_type],
        attachable_id: params[:attachable_id]
      ).order(created_at: :desc)
      render json: ::DocumentRepresenter.for_collection.new(records), status: :ok
    else
      render json: { error: 'attachable_type y attachable_id son requeridos' }, status: :unprocessable_entity
    end
  end

  def create
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
    document.file.purge if document.file.attached?
    document.destroy!
    head :no_content
  end

  private

  def document_params
    params.permit(:attachable_type, :attachable_id, :description, :file_type, :file)
  end
end
